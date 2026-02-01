import 'package:posts_challenge/features/posts/domain/entities/post.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
    );
  }
}
