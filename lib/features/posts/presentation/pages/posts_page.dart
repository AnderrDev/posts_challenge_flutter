import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
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
                      itemCount: state.filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final post = state.filtered[index];
                        final isLiked = state.likedIds.contains(post.id);

                        return PostListItem(
                          post: post,
                          isLiked: isLiked,
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
