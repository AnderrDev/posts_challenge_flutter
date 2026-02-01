import 'package:fpdart/fpdart.dart';

import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';
import 'package:posts_challenge/features/posts/domain/entities/comment.dart';
import 'package:posts_challenge/features/posts/domain/repositories/posts_repository.dart';
import 'package:posts_challenge/features/posts/data/datasources/posts_local_datasource.dart';
import 'package:posts_challenge/features/posts/data/datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl(this._remote, this._local);

  final PostsRemoteDatasource _remote;
  final PostsLocalDataSource _local;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    final res = await _remote.fetchPosts();

    return res.fold((failure) => Left(failure), (models) async {
      try {
        final likedIds = await _local.getLikedPostIds();
        final likedSet = likedIds.toSet();

        final posts = models
            .map((model) {
              // Model is already an Entity, just copyWith if needed or cast
              // Since PostModel extends PostEntity, we can treat it as Entity.
              // However, copyWith returns PostEntity.
              return model.copyWith(
                isLiked: likedSet.contains(model.id.toString()),
              );
            })
            .toList(growable: false);

        return Right(posts);
      } catch (e) {
        // Fallback: Return raw models as entities
        return Right(List<PostEntity>.from(models));
      }
    });
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPost(
    int postId,
  ) async {
    final res = await _remote.fetchCommentsByPost(postId);
    return res.map((models) => List<CommentEntity>.from(models));
  }

  @override
  Future<Either<Failure, void>> toggleLike(int postId) async {
    try {
      final likedIds = await _local.getLikedPostIds();
      final idStr = postId.toString();
      if (likedIds.contains(idStr)) {
        await _local.removeLikedPostId(postId);
      } else {
        await _local.saveLikedPostId(postId);
      }
      return const Right(null);
    } catch (e) {
      // We could define a CacheFailure here
      return const Left(
        ServerFailure(),
      ); // Using existing failure for now, or create a specific one
    }
  }
}
