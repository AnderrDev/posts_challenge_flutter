import 'package:fpdart/fpdart.dart';

import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';
import 'package:posts_challenge/features/posts/domain/entities/comment.dart';
import 'package:posts_challenge/features/posts/domain/repositories/posts_repository.dart';
import 'package:posts_challenge/features/posts/data/datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl(this._remote);

  final PostsRemoteDatasource _remote;

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    final res = await _remote.fetchPosts();
    return res.map(
      (dtos) => dtos.map((e) => e.toEntity()).toList(growable: false),
    );
  }

  @override
  Future<Either<Failure, List<Comment>>> getCommentsByPost(int postId) async {
    final res = await _remote.fetchCommentsByPost(postId);
    return res.map(
      (dtos) => dtos.map((e) => e.toEntity()).toList(growable: false),
    );
  }
}
