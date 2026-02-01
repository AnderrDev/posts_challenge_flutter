import 'package:equatable/equatable.dart';

import 'package:posts_challenge/features/posts/domain/entities/comment.dart';

enum CommentsStatus { initial, loading, success, failure }

class CommentsState extends Equatable {
  const CommentsState({
    required this.status,
    required this.comments,
    this.errorMessage,
  });

  const CommentsState.initial()
    : status = CommentsStatus.initial,
      comments = const [],
      errorMessage = null;

  final CommentsStatus status;
  final List<CommentEntity> comments;
  final String? errorMessage;

  CommentsState copyWith({
    CommentsStatus? status,
    List<CommentEntity>? comments,
    String? errorMessage,
  }) {
    return CommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, comments, errorMessage];
}
