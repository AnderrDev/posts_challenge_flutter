import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  // El método 'call' permite usar la instancia como si fuera una función:
  // getPostsUseCase()
  Future<Either<Failure, List<Post>>> call() {
    return repository.getPosts();
  }
}
