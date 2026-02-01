import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/core.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Dio + HttpClient (DIP)
  sl.registerLazySingleton<Dio>(() => buildDio());
  sl.registerLazySingleton<HttpClient>(() => DioHttpClient(sl<Dio>()));

  // Más adelante registramos:
  // - Datasources
  // - Repos
  // - UseCases
  // - BLoCs/Cubits
}
