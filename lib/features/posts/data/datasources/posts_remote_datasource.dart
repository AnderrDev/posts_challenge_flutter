import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../dtos/dtos.dart';

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
