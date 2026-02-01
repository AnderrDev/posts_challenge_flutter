import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/core/network/http_client.dart';
import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:posts_challenge/features/posts/data/models/post_model.dart';
import 'package:posts_challenge/features/posts/data/models/comment_model.dart';
import 'package:posts_challenge/core/network/endpoints.dart';

import 'posts_remote_datasource_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late PostsRemoteDatasourceImpl datasource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    provideDummy<Either<Failure, List<dynamic>>>(const Left(ServerFailure()));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = PostsRemoteDatasourceImpl(mockHttpClient);
  });

  const tPostModelList = [
    PostModel(id: 1, userId: 1, title: 'test title', body: 'test body'),
  ];

  const tCommentModelList = [
    CommentModel(postId: 1, id: 1, name: 'name', email: 'email', body: 'body'),
  ];

  group('fetchPosts', () {
    test(
      'should return a list of PostModel when the response is successful',
      () async {
        // arrange
        when(mockHttpClient.getList(any)).thenAnswer(
          (_) async => const Right([
            {"userId": 1, "id": 1, "title": "test title", "body": "test body"},
          ]),
        );
        // act
        final result = await datasource.fetchPosts();
        // assert
        expect(result.fold((l) => null, (r) => r), tPostModelList);
        verify(mockHttpClient.getList(Endpoints.posts));
      },
    );

    test('should return a Failure when the response is unsuccessful', () async {
      // arrange
      when(
        mockHttpClient.getList(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await datasource.fetchPosts();
      // assert
      expect(result, Left(ServerFailure()));
    });
  });

  group('fetchCommentsByPost', () {
    const tPostId = 1;

    test(
      'should return a list of CommentModel when the response is successful',
      () async {
        // arrange
        when(mockHttpClient.getList(any)).thenAnswer(
          (_) async => const Right([
            {
              "postId": 1,
              "id": 1,
              "name": "name",
              "email": "email",
              "body": "body",
            },
          ]),
        );
        // act
        final result = await datasource.fetchCommentsByPost(tPostId);
        // assert
        expect(result.fold((l) => null, (r) => r), tCommentModelList);
        verify(mockHttpClient.getList(Endpoints.commentsByPost(tPostId)));
      },
    );

    test('should return a Failure when the response is unsuccessful', () async {
      // arrange
      when(
        mockHttpClient.getList(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await datasource.fetchCommentsByPost(tPostId);
      // assert
      expect(result, Left(ServerFailure()));
    });
  });
}
