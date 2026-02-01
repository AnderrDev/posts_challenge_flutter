import 'package:posts_challenge/features/posts/domain/entities/post.dart';

class PostDto {
  const PostDto({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int userId;
  final int id;
  final String title;
  final String body;

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      userId: (json['userId'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
    );
  }

  Post toEntity() {
    return Post(userId: userId, id: id, title: title, body: body);
  }
}
