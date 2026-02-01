import 'package:shared_preferences/shared_preferences.dart';

abstract interface class PostsLocalDataSource {
  Future<List<String>> getLikedPostIds();
  Future<void> saveLikedPostId(int postId);
  Future<void> removeLikedPostId(int postId);
}

class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  PostsLocalDataSourceImpl(this._prefs);

  static const _likedPostsKey = 'liked_posts';
  final SharedPreferences _prefs;

  @override
  Future<List<String>> getLikedPostIds() async {
    return _prefs.getStringList(_likedPostsKey) ?? [];
  }

  @override
  Future<void> saveLikedPostId(int postId) async {
    final list = await getLikedPostIds();
    final idStr = postId.toString();
    if (!list.contains(idStr)) {
      await _prefs.setStringList(_likedPostsKey, [...list, idStr]);
    }
  }

  @override
  Future<void> removeLikedPostId(int postId) async {
    final list = await getLikedPostIds();
    final idStr = postId.toString();
    if (list.contains(idStr)) {
      final newList = List<String>.from(list)..remove(idStr);
      await _prefs.setStringList(_likedPostsKey, newList);
    }
  }
}
