import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/posts/domain/entities/post.dart';
import 'features/posts/presentation/pages/post_detail_page.dart';
import 'features/posts/presentation/pages/posts_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const PostsPage()),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! PostEntity) {
          return const Scaffold(
            body: Center(child: Text('Post no encontrado (missing extra)')),
          );
        }
        return PostDetailPage(post: extra);
      },
    ),
  ],
);
