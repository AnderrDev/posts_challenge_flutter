import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/features/posts/domain/repositories/posts_repository.dart';
import 'package:posts_challenge/features/posts/domain/usecases/get_posts.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';
import 'package:posts_challenge/core/error/failure.dart';

import 'get_posts_test.mocks.dart';

@GenerateMocks([PostsRepository])
void main() {
  late GetPosts usecase;
  late MockPostsRepository mockPostsRepository;

  setUpAll(() {
    provideDummy<Either<Failure, List<PostEntity>>>(
      const Left(ServerFailure()),
    );
  });

  setUp(() {
    mockPostsRepository = MockPostsRepository();
    usecase = GetPosts(mockPostsRepository);
  });

  const tPosts = [
    PostEntity(id: 1, userId: 1, title: 'test title', body: 'test body'),
  ];

  test('should get posts from the repository', () async {
    // arrange
    when(
      mockPostsRepository.getPosts(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer((_) async => const Right(tPosts));
    // act
    final result = await usecase();
    // assert
    expect(result, const Right(tPosts));
    verify(mockPostsRepository.getPosts(page: 1, limit: 10));
    verifyNoMoreInteractions(mockPostsRepository);
  });

  test(
    'should return a Failure when the repository call is unsuccessful',
    () async {
      // arrange
      when(
        mockPostsRepository.getPosts(),
      ).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await usecase();
      // assert
      expect(result, Left(ServerFailure()));
      verify(mockPostsRepository.getPosts(page: 1, limit: 10));
      verifyNoMoreInteractions(mockPostsRepository);
    },
  );
}
