class NetworkException implements Exception {
  NetworkException([this.message = 'Network exception']);
  final String message;
}

class ServerException implements Exception {
  ServerException([this.message = 'Server exception']);
  final String message;
}
