import 'package:fpdart/fpdart.dart';

import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';
import 'package:posts_challenge/features/posts/domain/entities/comment.dart';

abstract interface class PostsRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPost(int postId);
  Future<Either<Failure, void>> toggleLike(int postId);
}
