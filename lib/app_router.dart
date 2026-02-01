import 'package:go_router/go_router.dart';
import 'features/posts/domain/entities/post.dart';
import 'features/posts/presentation/pages/liked_posts_page.dart';
import 'features/posts/presentation/pages/post_detail_page.dart';
import 'features/posts/presentation/pages/posts_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const PostsPage()),
    GoRoute(
      path: '/liked-posts',
      builder: (context, state) => const LikedPostsPage(),
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final extra = state.extra as PostEntity?;
        return PostDetailPage(postId: id, post: extra);
      },
    ),
  ],
);
