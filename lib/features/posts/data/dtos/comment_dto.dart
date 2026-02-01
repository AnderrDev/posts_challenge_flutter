import '../../domain/entities/comment.dart';

class CommentDto {
  const CommentDto({
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

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      postId: (json['postId'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
    );
  }

  Comment toEntity() {
    return Comment(
      postId: postId,
      id: id,
      name: name,
      email: email,
      body: body,
    );
  }
}
