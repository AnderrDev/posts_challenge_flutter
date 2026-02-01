import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';
import 'package:posts_challenge/features/posts/domain/usecases/get_posts.dart';
import 'package:posts_challenge/features/posts/domain/usecases/toggle_post_like.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc({
    required GetPosts getPosts,
    required TogglePostLike togglePostLike,
  }) : _getPosts = getPosts,
       _togglePostLike = togglePostLike,
       super(const PostsState.initial()) {
    on<FetchPosts>(_onFetchPosts);
    on<SearchChanged>(_onSearchChanged);
    on<LikeToggled>(_onLikeToggled);
  }

  final GetPosts _getPosts;
  final TogglePostLike _togglePostLike;

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
    emit(state.copyWith(status: PostsStatus.loading, errorMessage: null));

    final result = await _getPosts();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PostsStatus.failure,
          errorMessage: _mapFailure(failure),
        ),
      ),
      (posts) => emit(
        state.copyWith(
          status: PostsStatus.success,
          posts: posts,
          filtered: _applyQuery(posts, state.query),
          errorMessage: null,
        ),
      ),
    );
  }

  void _onSearchChanged(SearchChanged event, Emitter<PostsState> emit) {
    final query = event.query;
    final filtered = _applyQuery(state.posts, query);

    emit(state.copyWith(query: query, filtered: filtered));
  }

  Future<void> _onLikeToggled(
    LikeToggled event,
    Emitter<PostsState> emit,
  ) async {
    final postToToggle = event.post;
    final isLikedBefore = postToToggle.isLiked;
    final newIsLiked = !isLikedBefore;

    // Optimistic Update
    final updatedPosts = state.posts
        .map((p) {
          return p.id == postToToggle.id ? p.copyWith(isLiked: newIsLiked) : p;
        })
        .toList(growable: false);

    emit(
      state.copyWith(
        posts: updatedPosts,
        filtered: _applyQuery(updatedPosts, state.query),
      ),
    );

    // Persistence
    final result = await _togglePostLike(postToToggle.id);

    result.fold(
      (failure) {
        // Revert on failure
        final revertedPosts = state.posts
            .map((p) {
              return p.id == postToToggle.id
                  ? p.copyWith(isLiked: isLikedBefore)
                  : p;
            })
            .toList(growable: false);

        emit(
          state.copyWith(
            posts: revertedPosts,
            filtered: _applyQuery(revertedPosts, state.query),
            // Optionally show error message
          ),
        );
      },
      (_) {}, // Success, stay optimistic
    );
  }

  List<PostEntity> _applyQuery(List<PostEntity> posts, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return posts;

    return posts
        .where((p) {
          return p.title.toLowerCase().contains(q) ||
              p.body.toLowerCase().contains(q);
        })
        .toList(growable: false);
  }

  String _mapFailure(Failure failure) => failure.message;
}
