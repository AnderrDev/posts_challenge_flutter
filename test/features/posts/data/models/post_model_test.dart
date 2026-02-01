import 'package:flutter_test/flutter_test.dart';
import 'package:posts_challenge/features/posts/data/models/post_model.dart';
import 'package:posts_challenge/features/posts/domain/entities/post.dart';

void main() {
  const tPostModel = PostModel(
    id: 1,
    userId: 1,
    title: 'test title',
    body: 'test body',
  );

  test('should be a subclass of PostEntity', () async {
    expect(tPostModel, isA<PostEntity>());
  });

  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap = {
      "userId": 1,
      "id": 1,
      "title": "test title",
      "body": "test body",
    };
    // act
    final result = PostModel.fromJson(jsonMap);
    // assert
    expect(result, tPostModel);
  });
}
