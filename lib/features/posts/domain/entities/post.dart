import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  // Este campo es crucial para el requerimiento de "Like" local
  final bool isLiked;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isLiked = false, // Por defecto no tiene like
  });

  // Método helper para inmutabilidad (muy útil en BLoC)
  Post copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [id, userId, title, body, isLiked];
}
