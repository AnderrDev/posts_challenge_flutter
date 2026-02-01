import 'package:dio/dio.dart';
import 'endpoints.dart';

Dio buildDio() {
  return Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
