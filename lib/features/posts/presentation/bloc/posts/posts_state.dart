import 'package:equatable/equatable.dart';

import 'package:posts_challenge/features/posts/domain/entities/post.dart';

enum PostsStatus { initial, loading, success, failure }

class PostsState extends Equatable {
  const PostsState({
    required this.status,
    required this.posts,
    required this.filtered,
    required this.query,
    this.errorMessage,
  });

  const PostsState.initial()
    : status = PostsStatus.initial,
      posts = const [],
      filtered = const [],
      query = '',
      errorMessage = null;

  final PostsStatus status;
  final List<PostEntity> posts;
  final List<PostEntity> filtered;
  final String query;
  final String? errorMessage;

  PostsState copyWith({
    PostsStatus? status,
    List<PostEntity>? posts,
    List<PostEntity>? filtered,
    String? query,
    String? errorMessage,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, filtered, query, errorMessage];
}
