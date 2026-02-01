import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_challenge/di/injector.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/comments/comments_cubit.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/comments/comments_state.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_event.dart';

import 'package:posts_challenge/features/posts/presentation/widgets/comments_list.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.postId, this.post});

  final int postId;
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CommentsCubit>()..load(postId),
      child: _PostDetailView(postId: postId, post: post),
    );
  }
}

class _PostDetailView extends StatelessWidget {
  const _PostDetailView({required this.postId, this.post});

  final int postId;
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    // Watch the specific post in the list to react to changes (like toggle)
    // If not found in list (shouldn't happen usually), fallback to passed post
    final currentPost = context.select<PostsBloc, PostEntity?>((bloc) {
      try {
        return bloc.state.posts.firstWhere((p) => p.id == postId);
      } catch (_) {
        return post;
      }
    });

    if (currentPost == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: const Center(child: Text('Post no encontrado')),
      );
    }

    final isLiked = currentPost.isLiked;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<PostsBloc>().add(LikeToggled(currentPost)),
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            currentPost.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(currentPost.body),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Comentarios',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 8),
              BlocBuilder<CommentsCubit, CommentsState>(
                buildWhen: (prev, curr) => prev.status != curr.status,
                builder: (context, state) {
                  if (state.status == CommentsStatus.loading) {
                    return const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<CommentsCubit, CommentsState>(
            builder: (context, state) {
              switch (state.status) {
                case CommentsStatus.loading:
                  return const SizedBox.shrink();

                case CommentsStatus.failure:
                  return Text(
                    state.errorMessage ?? 'Error cargando comentarios',
                  );

                case CommentsStatus.success:
                  return CommentsList(comments: state.comments);

                case CommentsStatus.initial:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
