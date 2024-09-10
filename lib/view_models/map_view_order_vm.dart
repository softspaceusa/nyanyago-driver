import 'dart:convert';
import 'dart:developer';

import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_driver_api.dart';
import 'package:nanny_core/api/web_sockets/nanny_web_socket.dart';
import 'package:nanny_core/map_services/location_service.dart';
import 'package:nanny_core/models/from_api/drive_and_map/one_time_drive_socket.dart';

class MapViewOrderVm extends ViewModelBase {
  final String driveToken;
  final int orderId;
  late final NannyWebSocket searchSocket;

  MapViewOrderVm(
      {required super.context,
      required super.update,
      required this.orderId,
      required this.driveToken}) {
    log('drive token found ${driveToken}');
    initSocket();
  }

  Future<void> initSocket() async {
    searchSocket = await OrdersSearchSocket(driveToken).connect();
    initListen();
  }

  void initListen() {
    searchSocket.stream.listen((v) {});
  }

  Future<void> onRideStart() async {
    final location =
        LocationService.curLoc ?? await LocationService.location.getLocation();
   var data = {
     "id_order": orderId,
     "lat": location.latitude,
     "lon": location.longitude,
     "type": "order",
     "flag": "startDrive"
   };
    // NannyDriverApi.changeOrderStatus().then((v) {
    //   log('order status changed ${v}');
    // });
    // print('data start ride ${data}');
    searchSocket.sink.add(jsonEncode(data));
  }

  Future<void> onDecline() async {}
}
