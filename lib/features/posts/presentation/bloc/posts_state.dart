import 'package:equatable/equatable.dart';

import '../../domain/entities/post.dart';

enum PostsStatus { initial, loading, success, failure }

class PostsState extends Equatable {
  const PostsState({
    required this.status,
    required this.posts,
    required this.filtered,
    required this.query,
    required this.likedIds,
    this.errorMessage,
  });

  const PostsState.initial()
    : status = PostsStatus.initial,
      posts = const [],
      filtered = const [],
      query = '',
      likedIds = const {},
      errorMessage = null;

  final PostsStatus status;
  final List<Post> posts;
  final List<Post> filtered;
  final String query;
  final Set<int> likedIds;
  final String? errorMessage;

  PostsState copyWith({
    PostsStatus? status,
    List<Post>? posts,
    List<Post>? filtered,
    String? query,
    Set<int>? likedIds,
    String? errorMessage,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
      likedIds: likedIds ?? this.likedIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    filtered,
    query,
    likedIds,
    errorMessage,
  ];
}
