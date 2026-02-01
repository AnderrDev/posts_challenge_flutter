import 'package:flutter/material.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onTap,
    required this.onLikeTap,
  });

  final Post post;
  final bool isLiked;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(post.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        onPressed: onLikeTap,
        icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
      ),
    );
  }
}
