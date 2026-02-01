import 'package:equatable/equatable.dart';

import '../../domain/entities/post.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchPosts extends PostsEvent {
  const FetchPosts();
}

final class SearchChanged extends PostsEvent {
  const SearchChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

final class LikeToggled extends PostsEvent {
  const LikeToggled(this.post);
  final Post post;

  @override
  List<Object?> get props => [post];
}
