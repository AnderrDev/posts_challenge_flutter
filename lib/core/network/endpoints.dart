class Endpoints {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';
  static const posts = '/posts';
  static String commentsByPost(int id) => '/posts/$id/comments';
}
