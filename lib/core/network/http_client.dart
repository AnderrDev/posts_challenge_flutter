import 'package:fpdart/fpdart.dart';
import 'package:posts_challenge/core/error/failure.dart';

abstract interface class HttpClient {
  Future<Either<Failure, List<dynamic>>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
  });
}
