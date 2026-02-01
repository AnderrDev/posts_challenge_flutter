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
    this.hasReachedMax = false,
    this.page = 1,
  });

  const PostsState.initial()
    : status = PostsStatus.initial,
      posts = const [],
      filtered = const [],
      query = '',
      errorMessage = null,
      hasReachedMax = false,
      page = 1;

  final PostsStatus status;
  final List<PostEntity> posts;
  final List<PostEntity> filtered;
  final String query;
  final String? errorMessage;
  final bool hasReachedMax;
  final int page;

  PostsState copyWith({
    PostsStatus? status,
    List<PostEntity>? posts,
    List<PostEntity>? filtered,
    String? query,
    String? errorMessage,
    bool? hasReachedMax,
    int? page,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    filtered,
    query,
    errorMessage,
    hasReachedMax,
    page,
  ];
}
