import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/core/error/failure.dart';
import 'http_client.dart';

class DioHttpClient implements HttpClient {
  DioHttpClient(Dio dio) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<Failure, List<dynamic>>> getList(String path) async {
    try {
      final res = await _dio.get(path);
      final data = res.data;

      if (data is List<dynamic>) {
        return Right(data);
      }
      return const Left(
        ServerFailure('Unexpected response format (expected List)'),
      );
    } on DioException catch (e) {
      // Mapeo simple (suficiente para el reto)
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure(e.message ?? 'Connection error'));
      }
      final status = e.response?.statusCode;
      return Left(
        ServerFailure('HTTP error${status != null ? ' ($status)' : ''}'),
      );
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
