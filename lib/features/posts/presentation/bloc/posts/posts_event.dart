import 'package:equatable/equatable.dart';

import 'package:posts_challenge/features/posts/domain/entities/post.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchPosts extends PostsEvent {
  const FetchPosts({this.refresh = false});
  final bool refresh;

  @override
  List<Object?> get props => [refresh];
}

final class SearchChanged extends PostsEvent {
  const SearchChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

final class LikeToggled extends PostsEvent {
  const LikeToggled(this.post);
  final PostEntity post;

  @override
  List<Object?> get props => [post];
}
