import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/core.dart';
import '../features/posts/posts.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Core: Dio + HttpClient (DIP)
  sl.registerLazySingleton<Dio>(() => buildDio());
  sl.registerLazySingleton<HttpClient>(() => DioHttpClient(sl<Dio>()));

  // Datasources
  sl.registerLazySingleton<PostsRemoteDatasource>(
    () => PostsRemoteDatasourceImpl(sl<HttpClient>()),
  );

  // Repositories
  sl.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(sl<PostsRemoteDatasource>()),
  );

  // UseCases
  sl.registerFactory<GetPosts>(() => GetPosts(sl<PostsRepository>()));
  sl.registerFactory<GetCommentsByPost>(
    () => GetCommentsByPost(sl<PostsRepository>()),
  );

  // Bloc
  sl.registerFactory<PostsBloc>(() => PostsBloc(getPosts: sl<GetPosts>()));
  sl.registerFactory<CommentsCubit>(
    () => CommentsCubit(getCommentsByPost: sl<GetCommentsByPost>()),
  );
}
