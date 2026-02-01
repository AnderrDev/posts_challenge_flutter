import 'package:fpdart/fpdart.dart';

import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/core/network/http_client.dart';
import 'package:posts_challenge/core/network/endpoints.dart';
import 'package:posts_challenge/features/posts/data/dtos/post_dto.dart';
import 'package:posts_challenge/features/posts/data/dtos/comment_dto.dart';

abstract interface class PostsRemoteDatasource {
  Future<Either<Failure, List<PostDto>>> fetchPosts();
  Future<Either<Failure, List<CommentDto>>> fetchCommentsByPost(int postId);
}

class PostsRemoteDatasourceImpl implements PostsRemoteDatasource {
  PostsRemoteDatasourceImpl(this._client);

  final HttpClient _client;

  @override
  Future<Either<Failure, List<PostDto>>> fetchPosts() async {
    final res = await _client.getList(Endpoints.posts);

    return res.map((list) {
      final mapped = list
          .cast<Map<String, dynamic>>()
          .map(PostDto.fromJson)
          .toList(growable: false);
      return mapped;
    });
  }

  @override
  Future<Either<Failure, List<CommentDto>>> fetchCommentsByPost(
    int postId,
  ) async {
    final res = await _client.getList(Endpoints.commentsByPost(postId));

    return res.map((list) {
      final mapped = list
          .cast<Map<String, dynamic>>()
          .map(CommentDto.fromJson)
          .toList(growable: false);
      return mapped;
    });
  }
}
