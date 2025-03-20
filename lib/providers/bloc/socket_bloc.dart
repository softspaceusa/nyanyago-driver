import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_driver_api.dart';
import 'package:nanny_core/api/web_sockets/nanny_web_socket.dart';
import 'package:nanny_core/map_services/location_service.dart';
import 'package:nanny_core/models/from_api/drive_and_map/one_time_drive_socket.dart';
import 'package:nanny_driver/views/pages/map/map_view_order.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final BuildContext context;
  NannyWebSocket? searchSocket;
  StreamSubscription? socketSubscription;

  SocketBloc({required this.context}) : super(SocketInitial()) {
    on<StartSocket>(_onStartSocket);
    on<NewOrderReceived>(_onNewOrderReceived);
    on<StopSocket>(_onStopSocket);
  }

  Future<void> _onStartSocket(
      StartSocket event, Emitter<SocketState> emit) async {
    emit(SocketConnecting());
    try {
      var loc = LocationService.curLoc ??
          (await LocationService.location.getLocation());
      LocationService.curLoc = loc;
      var response = await NannyDriverApi.startDriveMode(
        LatLng(loc.latitude ?? 0, loc.longitude ?? 0),
      );

      if (response.success && response.response != null) {
        searchSocket = await OrdersSearchSocket(response.response!).connect();
        _listenToSocket();
        emit(SocketConnected());
      } else {
        emit(SocketError("Ошибка подключения к WebSocket"));
      }
    } catch (e) {
      emit(SocketError(e.toString()));
    }
  }

  void _listenToSocket() {
    if (searchSocket == null) return;

    socketSubscription = searchSocket!.stream.listen(
      (v) {
        try {
          var json = jsonDecode(v) as Map<String, dynamic>;
          if (json.containsKey('active_orders')) {
            var order =
                OneTimeDriveResponse.fromJson(json['active_orders'].first);
            add(NewOrderReceived(order));
          }
        } catch (e) {
          print("Ошибка при обработке WebSocket-сообщения: $e");
        }
      },
      onError: (error) => add(StopSocket()),
    );
  }

  Future _onNewOrderReceived(
      NewOrderReceived event, Emitter<SocketState> emit) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapViewOrder(
                myLocation: LatLng(LocationService.curLoc!.latitude ?? 0,
                    LocationService.curLoc!.longitude ?? 0),
                model: event.order.toUi(),
                searchSocket: searchSocket,
                orderId: event.order.idOrder!)));
  }

  Future<void> _onStopSocket(
      StopSocket event, Emitter<SocketState> emit) async {
    await socketSubscription?.cancel();
    searchSocket?.dispose();
    emit(SocketInitial());
  }

  @override
  Future<void> close() {
    socketSubscription?.cancel();
    searchSocket?.dispose();
    return super.close();
  }
}
