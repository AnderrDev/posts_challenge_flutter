import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/features/posts/domain/usecases/get_comments_by_post.dart';
import 'package:posts_challenge/features/posts/domain/entities/comment.dart';
import 'package:posts_challenge/core/error/failure.dart';

import 'get_posts_test.mocks.dart';

void main() {
  late GetCommentsByPost usecase;
  late MockPostsRepository mockPostsRepository;

  setUpAll(() {
    provideDummy<Either<Failure, List<CommentEntity>>>(
      const Left(ServerFailure()),
    );
  });

  setUp(() {
    mockPostsRepository = MockPostsRepository();
    usecase = GetCommentsByPost(mockPostsRepository);
  });

  const tPostId = 1;
  const tComments = [
    CommentEntity(
      postId: 1,
      id: 1,
      name: 'test name',
      email: 'test@email.com',
      body: 'test body',
    ),
  ];

  test('should get comments by post id from the repository', () async {
    // arrange
    when(
      mockPostsRepository.getCommentsByPost(any),
    ).thenAnswer((_) async => const Right(tComments));
    // act
    final result = await usecase(tPostId);
    // assert
    expect(result, const Right(tComments));
    verify(mockPostsRepository.getCommentsByPost(tPostId));
    verifyNoMoreInteractions(mockPostsRepository);
  });

  test(
    'should return a Failure when the repository call is unsuccessful',
    () async {
      // arrange
      when(
        mockPostsRepository.getCommentsByPost(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await usecase(tPostId);
      // assert
      expect(result, Left(ServerFailure()));
      verify(mockPostsRepository.getCommentsByPost(tPostId));
      verifyNoMoreInteractions(mockPostsRepository);
    },
  );
}
