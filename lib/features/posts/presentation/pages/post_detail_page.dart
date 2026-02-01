import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injector.dart';
import '../../domain/entities/post.dart';
import '../bloc/comments_cubit.dart';
import '../bloc/comments_state.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';

import '../widgets/comments_list.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CommentsCubit>()..load(post.id),
      child: _PostDetailView(post: post),
    );
  }
}

class _PostDetailView extends StatelessWidget {
  const _PostDetailView({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final isLiked = context.select<PostsBloc, bool>(
      (bloc) => bloc.state.likedIds.contains(post.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        actions: [
          IconButton(
            onPressed: () => context.read<PostsBloc>().add(LikeToggled(post)),
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(post.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(post.body),
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
