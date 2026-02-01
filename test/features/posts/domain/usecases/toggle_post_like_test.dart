import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/features/posts/domain/usecases/toggle_post_like.dart';
import 'package:posts_challenge/core/error/failure.dart';

import 'get_posts_test.mocks.dart';

void main() {
  late TogglePostLike usecase;
  late MockPostsRepository mockPostsRepository;

  setUpAll(() {
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  setUp(() {
    mockPostsRepository = MockPostsRepository();
    usecase = TogglePostLike(mockPostsRepository);
  });

  const tPostId = 1;

  test('should toggle post like in the repository', () async {
    // arrange
    when(
      mockPostsRepository.toggleLike(any),
    ).thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(tPostId);
    // assert
    expect(result, const Right(null));
    verify(mockPostsRepository.toggleLike(tPostId));
    verifyNoMoreInteractions(mockPostsRepository);
  });

  test(
    'should return a Failure when the repository call is unsuccessful',
    () async {
      // arrange
      when(
        mockPostsRepository.toggleLike(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await usecase(tPostId);
      // assert
      expect(result, Left(ServerFailure()));
      verify(mockPostsRepository.toggleLike(tPostId));
      verifyNoMoreInteractions(mockPostsRepository);
    },
  );
}
