import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_state.dart';
import 'package:posts_challenge/features/posts/presentation/widgets/post_list_item.dart';
import 'package:posts_challenge/features/posts/presentation/widgets/search_bar.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<PostsBloc>();
      if (bloc.state.query.isEmpty &&
          !bloc.state.hasReachedMax &&
          bloc.state.status != PostsStatus.loading) {
        bloc.add(const FetchPosts());
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

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
                  case PostsStatus.loading when state.posts.isEmpty:
                    return const Center(child: CircularProgressIndicator());

                  case PostsStatus.failure when state.posts.isEmpty:
                    return Center(child: Text(state.errorMessage ?? 'Error'));

                  case PostsStatus.success:
                  case PostsStatus.failure:
                  case PostsStatus.loading:
                    if (state.filtered.isEmpty) {
                      return const Center(child: Text('No hay resultados'));
                    }
                    return ListView.separated(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: state.hasReachedMax || state.query.isNotEmpty
                          ? state.filtered.length
                          : state.filtered.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index >= state.filtered.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

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
