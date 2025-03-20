part of 'socket_bloc.dart';

abstract class SocketEvent {}

class StartSocket extends SocketEvent {}

class NewOrderReceived extends SocketEvent {
  final OneTimeDriveResponse order;
  NewOrderReceived(this.order);
}

class StopSocket extends SocketEvent {}
