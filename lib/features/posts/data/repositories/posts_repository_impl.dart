import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../datasources/datasources.dart';

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
