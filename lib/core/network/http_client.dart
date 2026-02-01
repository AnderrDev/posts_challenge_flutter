import 'package:fpdart/fpdart.dart';
import '../error/failure.dart';

abstract interface class HttpClient {
  Future<Either<Failure, List<dynamic>>> getList(String path);
}
