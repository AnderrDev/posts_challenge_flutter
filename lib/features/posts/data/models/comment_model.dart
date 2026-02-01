import 'package:posts_challenge/features/posts/domain/entities/comment.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.postId,
    required super.id,
    required super.name,
    required super.email,
    required super.body,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      postId: (json['postId'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
    );
  }
}
