import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/comment.dart';
import '../repositories/posts_repository.dart';

class GetCommentsByPost {
  const GetCommentsByPost(this._repository);

  final PostsRepository _repository;

  Future<Either<Failure, List<Comment>>> call(int postId) {
    return _repository.getCommentsByPost(postId);
  }
}
