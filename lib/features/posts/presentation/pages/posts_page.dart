import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_state.dart';
import 'package:posts_challenge/features/posts/presentation/widgets/post_list_item.dart';
import 'package:posts_challenge/features/posts/presentation/widgets/search_bar.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/liked-posts'),
            tooltip: 'Posts Favoritos',
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchBarWidget(),
          Expanded(
            child: BlocBuilder<PostsBloc, PostsState>(
              builder: (context, state) {
                switch (state.status) {
                  case PostsStatus.loading:
                    return const Center(child: CircularProgressIndicator());

                  case PostsStatus.failure:
                    return Center(child: Text(state.errorMessage ?? 'Error'));

                  case PostsStatus.success:
                    if (state.filtered.isEmpty) {
                      return const Center(child: Text('No hay resultados'));
                    }
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final post = state.filtered[index];

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

                  case PostsStatus.initial:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
