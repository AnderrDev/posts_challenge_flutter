import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:posts_challenge/core/network/dio_client.dart';
import 'package:posts_challenge/core/network/dio_http_client.dart';
import 'package:posts_challenge/core/network/http_client.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/comments_cubit.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:posts_challenge/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:posts_challenge/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:posts_challenge/features/posts/domain/repositories/posts_repository.dart';
import 'package:posts_challenge/features/posts/domain/usecases/get_comments_by_post.dart';
import 'package:posts_challenge/features/posts/domain/usecases/get_posts.dart';

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
