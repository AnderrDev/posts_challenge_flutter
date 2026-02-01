import 'package:fpdart/fpdart.dart';

import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/entities/comment.dart';
import 'package:posts_challenge/features/posts/domain/repositories/posts_repository.dart';

class GetCommentsByPost {
  const GetCommentsByPost(this._repository);

  final PostsRepository _repository;

  Future<Either<Failure, List<Comment>>> call(int postId) {
    return _repository.getCommentsByPost(postId);
  }
}
