import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_state.dart';
import 'package:posts_challenge/features/posts/domain/usecases/get_posts.dart';
import 'package:posts_challenge/features/posts/domain/usecases/toggle_post_like.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';
import 'package:posts_challenge/core/error/failure.dart';

import 'posts_bloc_test.mocks.dart';

@GenerateMocks([GetPosts, TogglePostLike])
void main() {
  late PostsBloc bloc;
  late MockGetPosts mockGetPosts;
  late MockTogglePostLike mockTogglePostLike;

  setUpAll(() {
    provideDummy<Either<Failure, List<PostEntity>>>(
      const Left(ServerFailure()),
    );
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  setUp(() {
    mockGetPosts = MockGetPosts();
    mockTogglePostLike = MockTogglePostLike();
    bloc = PostsBloc(
      getPosts: mockGetPosts,
      togglePostLike: mockTogglePostLike,
    );
  });

  const tPost = PostEntity(
    id: 1,
    userId: 1,
    title: 'test title',
    body: 'test body',
    isLiked: false,
  );

  const tPostLiked = PostEntity(
    id: 1,
    userId: 1,
    title: 'test title',
    body: 'test body',
    isLiked: true,
  );

  test('initial state should be PostsState.initial()', () {
    expect(bloc.state, const PostsState.initial());
  });

  blocTest<PostsBloc, PostsState>(
    'emits [loading, success] when FetchPosts is added and returns posts',
    build: () {
      when(
        mockGetPosts(page: anyNamed('page'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => const Right([tPost]));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchPosts()),
    expect: () => [
      const PostsState(
        status: PostsStatus.loading,
        posts: [],
        filtered: [],
        query: '',
        errorMessage: null,
        hasReachedMax: false,
        page: 1,
      ),
      const PostsState(
        status: PostsStatus.success,
        posts: [tPost],
        filtered: [tPost],
        query: '',
        errorMessage: null,
        hasReachedMax: true,
        page: 2,
      ),
    ],
    verify: (_) {
      verify(mockGetPosts(page: 1, limit: 10));
    },
  );

  blocTest<PostsBloc, PostsState>(
    'emits [loading, failure] when FetchPosts is added and returns failure',
    build: () {
      when(
        mockGetPosts(page: anyNamed('page'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchPosts()),
    expect: () => [
      const PostsState(
        status: PostsStatus.loading,
        posts: [],
        filtered: [],
        query: '',
        errorMessage: null,
        hasReachedMax: false,
        page: 1,
      ),
      const PostsState(
        status: PostsStatus.failure,
        posts: [],
        filtered: [],
        query: '',
        errorMessage: 'Server error',
        hasReachedMax: false,
        page: 1,
      ),
    ],
    verify: (_) {
      verify(mockGetPosts(page: 1, limit: 10));
    },
  );

  blocTest<PostsBloc, PostsState>(
    'emits state with filtered posts when SearchChanged is added',
    build: () {
      // We need to seed the state with posts
      // But blocTest build returns the bloc.
      // We can use seed but we construct the bloc manually.
      // Alternatively, we can chain FetchPosts then SearchChanged, but that makes it complex.
      // Better to emit a state manually? No, bloc.emit is protected.
      // We can use `seed` parameter in blocTest if we want initial state different from initial.
      // But `bloc` is created in `build`.
      // Let's rely on FetchPosts first.
      when(
        mockGetPosts(page: anyNamed('page'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => const Right([tPost]));
      return bloc;
    },
    seed: () => const PostsState(
      status: PostsStatus.success,
      posts: [tPost],
      filtered: [tPost],
      query: '',
      errorMessage: null,
      hasReachedMax: true,
      page: 2,
    ),
    act: (bloc) => bloc.add(const SearchChanged('invalid')),
    expect: () => [
      const PostsState(
        status: PostsStatus.success,
        posts: [tPost],
        filtered: [],
        query: 'invalid',
        errorMessage: null,
        hasReachedMax: true,
        page: 2,
      ),
    ],
  );

  blocTest<PostsBloc, PostsState>(
    'emits optimistic update and persists when LikeToggled is added',
    build: () {
      when(mockTogglePostLike(any)).thenAnswer((_) async => const Right(null));
      return bloc;
    },
    seed: () => const PostsState(
      status: PostsStatus.success,
      posts: [tPost],
      filtered: [tPost],
      query: '',
      errorMessage: null,
      hasReachedMax: true,
      page: 2,
    ),
    act: (bloc) => bloc.add(const LikeToggled(tPost)),
    expect: () => [
      const PostsState(
        status: PostsStatus.success,
        posts: [tPostLiked],
        filtered: [tPostLiked],
        query: '',
        errorMessage: null,
        hasReachedMax: true,
        page: 2,
      ),
    ],
    verify: (_) {
      verify(mockTogglePostLike(tPost.id));
    },
  );

  blocTest<PostsBloc, PostsState>(
    'reverts optimistic update when LikeToggled fails',
    build: () {
      when(
        mockTogglePostLike(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    seed: () => const PostsState(
      status: PostsStatus.success,
      posts: [tPost],
      filtered: [tPost],
      query: '',
      errorMessage: null,
      hasReachedMax: true,
      page: 2,
    ),
    act: (bloc) => bloc.add(const LikeToggled(tPost)),
    expect: () => [
      const PostsState(
        status: PostsStatus.success,
        posts: [tPostLiked],
        filtered: [tPostLiked],
        query: '',
        errorMessage: null,
        hasReachedMax: true,
        page: 2,
      ),
      const PostsState(
        status: PostsStatus.success,
        posts: [tPost],
        filtered: [tPost],
        query: '',
        errorMessage: null,
        hasReachedMax: true,
        page: 2,
      ),
    ],
    verify: (_) {
      verify(mockTogglePostLike(tPost.id));
    },
  );
}
