import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Fallo específico de Servidor (API 500, 404, etc)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Fallo de conexión o red
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Fallo al comunicarse con el código nativo (Pigeon)
class NativeFailure extends Failure {
  const NativeFailure(super.message);
}
