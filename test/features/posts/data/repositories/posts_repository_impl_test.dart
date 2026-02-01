import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:posts_challenge/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:posts_challenge/features/posts/data/datasources/posts_local_datasource.dart';
import 'package:posts_challenge/features/posts/data/models/post_model.dart';
import 'package:posts_challenge/features/posts/data/models/comment_model.dart';
import 'package:posts_challenge/core/error/failure.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';

import 'posts_repository_impl_test.mocks.dart';

@GenerateMocks([PostsRemoteDatasource, PostsLocalDataSource])
void main() {
  late PostsRepositoryImpl repository;
  late MockPostsRemoteDatasource mockRemote;
  late MockPostsLocalDataSource mockLocal;

  setUpAll(() {
    provideDummy<Either<Failure, List<PostModel>>>(const Left(ServerFailure()));
    provideDummy<Either<Failure, List<CommentModel>>>(
      const Left(ServerFailure()),
    );
  });

  setUp(() {
    mockRemote = MockPostsRemoteDatasource();
    mockLocal = MockPostsLocalDataSource();
    repository = PostsRepositoryImpl(mockRemote, mockLocal);
  });

  const tPostModel = PostModel(
    id: 1,
    userId: 1,
    title: 'test title',
    body: 'test body',
  );

  const tPostEntity = PostEntity(
    id: 1,
    userId: 1,
    title: 'test title',
    body: 'test body',
    isLiked: false,
  );

  const tPostEntityLiked = PostEntity(
    id: 1,
    userId: 1,
    title: 'test title',
    body: 'test body',
    isLiked: true,
  );

  group('getPosts', () {
    test(
      'should return list of PostEntity with like status when remote call is successful',
      () async {
        // arrange
        when(
          mockRemote.fetchPosts(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => const Right([tPostModel]));
        when(mockLocal.getLikedPostIds()).thenAnswer((_) async => []);
        // act
        final result = await repository.getPosts();
        // assert
        verify(mockRemote.fetchPosts(page: 1, limit: 10));
        verify(mockLocal.getLikedPostIds());
        expect(result.fold((l) => null, (r) => r), [tPostEntity]);
      },
    );

    test(
      'should return list of PostEntity marked as liked when id is in local',
      () async {
        // arrange
        when(
          mockRemote.fetchPosts(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => const Right([tPostModel]));
        when(mockLocal.getLikedPostIds()).thenAnswer((_) async => ['1']);
        // act
        final result = await repository.getPosts();
        // assert
        verify(mockRemote.fetchPosts(page: 1, limit: 10));
        verify(mockLocal.getLikedPostIds());
        expect(result.fold((l) => null, (r) => r), [tPostEntityLiked]);
      },
    );

    test('should return Failure when remote call fails', () async {
      // arrange
      when(
        mockRemote.fetchPosts(page: anyNamed('page'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await repository.getPosts();
      // assert
      verify(mockRemote.fetchPosts(page: 1, limit: 10));
      verifyZeroInteractions(mockLocal);
      expect(result, Left(ServerFailure()));
    });
  });

  group('toggleLike', () {
    const tPostId = 1;

    test('should call saveLikedPostId when id is not liked', () async {
      // arrange
      when(mockLocal.getLikedPostIds()).thenAnswer((_) async => []);
      when(
        mockLocal.saveLikedPostId(any),
      ).thenAnswer((_) async => Future.value());
      // act
      final result = await repository.toggleLike(tPostId);
      // assert
      verify(mockLocal.getLikedPostIds());
      verify(mockLocal.saveLikedPostId(tPostId));
      expect(result, const Right<Failure, void>(null));
    });

    test('should call removeLikedPostId when id is liked', () async {
      // arrange
      when(mockLocal.getLikedPostIds()).thenAnswer((_) async => ['1']);
      when(
        mockLocal.removeLikedPostId(any),
      ).thenAnswer((_) async => Future.value());
      // act
      final result = await repository.toggleLike(tPostId);
      // assert
      verify(mockLocal.getLikedPostIds());
      verify(mockLocal.removeLikedPostId(tPostId));
      expect(result, const Right<Failure, void>(null));
    });
  });
}
