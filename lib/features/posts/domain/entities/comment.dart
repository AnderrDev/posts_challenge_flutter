import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  const CommentEntity({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  @override
  List<Object?> get props => [postId, id, name, email, body];
}
