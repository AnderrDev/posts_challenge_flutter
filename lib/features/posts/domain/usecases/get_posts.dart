import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/post.dart';
import '../repositories/posts_repository.dart';

class GetPosts {
  const GetPosts(this._repository);

  final PostsRepository _repository;

  Future<Either<Failure, List<Post>>> call() {
    return _repository.getPosts();
  }
}
