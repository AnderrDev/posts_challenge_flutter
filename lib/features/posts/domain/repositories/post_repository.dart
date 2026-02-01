import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  /// Obtiene la lista de posts.
  /// Retorna un [Failure] o una [List<Post>].
  Future<Either<Failure, List<Post>>> getPosts();

  /// Maneja la acción de dar/quitar like.
  /// Retorna un [Failure] o [void] (éxito sin datos).
  /// Recibe el post actual para saber si invocar la notificación nativa o no.
  Future<Either<Failure, void>> toggleLike(Post post);
}
