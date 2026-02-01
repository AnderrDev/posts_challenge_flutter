import 'package:flutter/material.dart';
import 'package:posts_challenge/features/posts/domain/entities/comment.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({super.key, required this.comments});

  final List<CommentEntity> comments;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Text('Sin comentarios');
    }

    return Column(
      children: comments
          .map((c) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(c.email, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(c.body),
                  ],
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
