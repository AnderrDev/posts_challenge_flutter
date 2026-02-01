import 'package:go_router/go_router.dart';

import 'features/posts/presentation/pages/posts_page.dart';

final appRouter = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const PostsPage())],
);
