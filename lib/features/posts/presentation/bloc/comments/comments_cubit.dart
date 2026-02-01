import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/usecases/get_comments_by_post.dart';
import 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit({required GetCommentsByPost getCommentsByPost})
    : _getCommentsByPost = getCommentsByPost,
      super(const CommentsState.initial());

  final GetCommentsByPost _getCommentsByPost;

  Future<void> load(int postId) async {
    emit(state.copyWith(status: CommentsStatus.loading, errorMessage: null));

    final result = await _getCommentsByPost(postId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CommentsStatus.failure,
          errorMessage: _mapFailure(failure),
        ),
      ),
      (comments) => emit(
        state.copyWith(
          status: CommentsStatus.success,
          comments: comments,
          errorMessage: null,
        ),
      ),
    );
  }

  String _mapFailure(Failure failure) => failure.message;
}
