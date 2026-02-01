import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/comments/comments_cubit.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/comments/comments_state.dart';
import 'package:posts_challenge/features/posts/domain/usecases/get_comments_by_post.dart';
import 'package:posts_challenge/features/posts/domain/entities/comment.dart';
import 'package:posts_challenge/core/error/failure.dart';

import 'comments_cubit_test.mocks.dart';

@GenerateMocks([GetCommentsByPost])
void main() {
  late CommentsCubit cubit;
  late MockGetCommentsByPost mockGetCommentsByPost;

  setUpAll(() {
    provideDummy<Either<Failure, List<CommentEntity>>>(
      const Left(ServerFailure()),
    );
  });

  setUp(() {
    mockGetCommentsByPost = MockGetCommentsByPost();
    cubit = CommentsCubit(getCommentsByPost: mockGetCommentsByPost);
  });

  const tComment = CommentEntity(
    postId: 1,
    id: 1,
    name: 'test name',
    email: 'test@email.com',
    body: 'test body',
  );

  test('initial state should be CommentsState.initial()', () {
    expect(cubit.state, const CommentsState.initial());
  });

  blocTest<CommentsCubit, CommentsState>(
    'emits [loading, success] when load is called and returns comments',
    build: () {
      when(
        mockGetCommentsByPost(any),
      ).thenAnswer((_) async => const Right([tComment]));
      return cubit;
    },
    act: (cubit) => cubit.load(1),
    expect:
        () => [
          const CommentsState(
            status: CommentsStatus.loading,
            comments: [],
            errorMessage: null,
          ),
          const CommentsState(
            status: CommentsStatus.success,
            comments: [tComment],
            errorMessage: null,
          ),
        ],
    verify: (_) {
      verify(mockGetCommentsByPost(1));
    },
  );

  blocTest<CommentsCubit, CommentsState>(
    'emits [loading, failure] when load is called and returns failure',
    build: () {
      when(
        mockGetCommentsByPost(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      return cubit;
    },
    act: (cubit) => cubit.load(1),
    expect:
        () => [
          const CommentsState(
            status: CommentsStatus.loading,
            comments: [],
            errorMessage: null,
          ),
          const CommentsState(
            status: CommentsStatus.failure,
            comments: [],
            errorMessage: 'Server error',
          ),
        ],
    verify: (_) {
      verify(mockGetCommentsByPost(1));
    },
  );
}
