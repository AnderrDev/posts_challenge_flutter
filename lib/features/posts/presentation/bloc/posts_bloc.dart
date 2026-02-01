import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc({required GetPosts getPosts})
    : _getPosts = getPosts,
      super(const PostsState.initial()) {
    on<FetchPosts>(_onFetchPosts);
    on<SearchChanged>(_onSearchChanged);
    on<LikeToggled>(_onLikeToggled);
  }

  final GetPosts _getPosts;

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

  void _onLikeToggled(LikeToggled event, Emitter<PostsState> emit) {
    final postId = event.post.id;

    final newLikedIds = Set<int>.from(state.likedIds);
    if (newLikedIds.contains(postId)) {
      newLikedIds.remove(postId);
    } else {
      newLikedIds.add(postId);
    }

    emit(state.copyWith(likedIds: newLikedIds));
  }

  List<Post> _applyQuery(List<Post> posts, String query) {
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
