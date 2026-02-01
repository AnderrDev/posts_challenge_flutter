import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_state.dart';
import 'package:posts_challenge/features/posts/presentation/widgets/post_list_item.dart';

class LikedPostsPage extends StatelessWidget {
  const LikedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts Favoritos')),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          final likedPosts = state.posts.where((post) => post.isLiked).toList();

          if (likedPosts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes posts favoritos',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Marca posts como favoritos para verlos aquí',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: likedPosts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = likedPosts[index];

              return PostListItem(
                post: post,
                onTap: () {
                  context.push('/post/${post.id}', extra: post);
                },
                onLikeTap: () {
                  context.read<PostsBloc>().add(LikeToggled(post));
                },
              );
            },
          );
        },
      ),
    );
  }
}
