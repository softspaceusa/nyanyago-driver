part of 'socket_bloc.dart';

abstract class SocketState {}

class SocketInitial extends SocketState {}

class SocketConnecting extends SocketState {}

class SocketConnected extends SocketState {}

class SocketError extends SocketState {
  final String message;
  SocketError(this.message);
}
