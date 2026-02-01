import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/entities.dart';

abstract interface class PostsRepository {
  Future<Either<Failure, List<Post>>> getPosts();
  Future<Either<Failure, List<Comment>>> getCommentsByPost(int postId);
}
