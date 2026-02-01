import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/repositories/posts_repository.dart';

import 'package:posts_challenge/features/posts/domain/entities/post.dart';

class TogglePostLike {
  const TogglePostLike(this._repository);

  final PostsRepository _repository;

  Future<Either<Failure, void>> call(PostEntity post) {
    return _repository.toggleLike(post);
  }
}
