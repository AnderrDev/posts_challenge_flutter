import 'package:fpdart/fpdart.dart';

import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';
import 'package:posts_challenge/features/posts/domain/repositories/posts_repository.dart';

class GetPosts {
  const GetPosts(this._repository);

  final PostsRepository _repository;

  Future<Either<Failure, List<PostEntity>>> call({
    int page = 1,
    int limit = 10,
  }) {
    return _repository.getPosts(page: page, limit: limit);
  }
}
