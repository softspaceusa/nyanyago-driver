import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/one_time_drive_widget.dart';
import 'package:nanny_core/api/api_models/search_query_request.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/api/web_sockets/nanny_web_socket.dart';
import 'package:nanny_core/models/from_api/drive_and_map/current_order_response.dart';
import 'package:nanny_core/models/from_api/drive_and_map/driver_schedule_response.dart';
import 'package:nanny_core/models/from_api/drive_and_map/one_time_drive_socket.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/views/pages/map/map_view_order.dart';

class OffersVM extends ViewModelBase {
  OffersVM({
    required super.context,
    required super.update,
  });

  Future load() async {
    //await loadOneTimeDrives();
    await initDriveMode();
  }

  List<Order> orders = [];
  var driveToken = '';
  var selectedId = 0;
  OfferType selectedOfferType = OfferType.route;
  List<OneTimeDriveModel> oneTimeDrive = [];
  List<DriverScheduleResponse> offers = [];
  List<OtherParametr> params = [];
  late NannyWebSocket searchSocket;

  Future<void> loadOneTimeDrives() async {
    final response = await NannyOrdersApi.getOnetimeOrder();
    update(() {
      oneTimeDrive = (response.response ?? []).map((e) => e.toUi()).toList();
    });
  }

  Future setSelected(int orderId) async {
    selectedId = orderId;
    update(() {});
  }

  Future<void> updateStatuses() async {
    var result = await NannyOrdersApi.getCurrentOrder();
    if (result.success) {
      orders = (result.response?.orders ?? []).toList();
      print('${orders.map((e) => "${e.idOrder}|${e.idStatus}|${e.idUser}")}');
    } else {
      return;
    }
    if (orders.isEmpty) return;
    for (var item in orders) {
      if (item.idStatus == 4) {
        searchSocket.sinkValue({'id_order': item.idOrder, 'status': 2});

        // NannyOrdersApi.acceptOrder(item.idOrder ?? 0);
        // return;
      }
      if (item.idStatus == 13) {
        searchSocket.sinkValue({'id_order': item.idOrder, 'status': 5});
      }
      if (item.idStatus == 5) {
        searchSocket.sinkValue({'id_order': item.idOrder, 'status': 7});
      }
      if (item.idStatus == 7) {
        searchSocket.sinkValue({'id_order': item.idOrder, 'status': 14});
      }
      if (item.idStatus == 14) {
        searchSocket.sinkValue({'id_order': item.idOrder, 'status': 15});
      }
      if (item.idStatus == 15) {
        searchSocket.sinkValue({'id_order': item.idOrder, 'status': 11});
      }
    }
  }

  Future<void> onCancel() async {
    if (selectedId == 0) return;
    var selected = selectedId;
    var order = oneTimeDrive.firstWhereOrNull((e) => e.orderId == selected);
    if (order != null) {
      update(() {
        oneTimeDrive.removeWhere((e) => e.orderId == selectedId);
        selectedId = 0;
      });
    }

    //if (order.orderId == selected) {
    //  searchSocket.sinkValue({
    //    "id_order": selected,
    //    "cancel": "true",
    //    "type": "order"
    //  }).then((v) async {
    //    //await loadOneTimeDrives();
    //  });
    //}
  }

  void onAccept() async {
    if (selectedId == 0) return;
    var loc = await LocationService.location.getLocation();
    navigateToView(
      MapViewOrder(
          myLocation: LatLng(loc.latitude ?? 0, loc.longitude ?? 0),
          model: oneTimeDrive.firstWhere((e) => e.orderId == selectedId),
          searchSocket: searchSocket,
          orderId: selectedId),
    ).then((v) async {
      await setSelected(0);

      //await loadOneTimeDrives();
      //await initDriveMode();
    });
    NannyOrdersApi.acceptOrder(selectedId);
    // if (oneTimeDrive.any((e) => e.isFromSocket)) {
    //   var order = oneTimeDrive.firstWhere((e) => e.isFromSocket);
    //   if (order.orderId == selectedId) {
    //     searchSocket.channel.sink
    //         .add('{"id_order": $selectedId, "accept": True, "type": "order"}');
    //   }
    // } else {
    //
    // }
  }

  Future<void> initDriveMode() async {
    var loc = LocationService.curLoc ??
        (await LocationService.location.getLocation());
    await NannyDriverApi.startDriveMode(
            LatLng(loc.latitude ?? 0, loc.longitude ?? 0))
        .then((v) async {
      if (v.success) {
        driveToken = v.response ?? '';
        searchSocket = await OrdersSearchSocket(v.response ?? '').connect();
        await initListen();
      }
    });
  }

  Future initListen() async {
    searchSocket.stream.listen((v) {
      if (v is Map<String, dynamic>) {
        if (v['id_order'] == null && v['order_id'] == null) return;
        var result = OneTimeDriveResponse.fromJson(v);
        update(() {
          if (oneTimeDrive.any((e) => e.orderId == result.idOrder)) return;
          oneTimeDrive.add(result.toUi());
          oneTimeDrive.sort((a, b) => a.isFromSocket ? 0 : 1);
        });
      } else if (v is String) {
        var value = jsonDecode(v);
        if (value['id_order'] == null && value['order_id'] == null) return;
        var result = OneTimeDriveResponse.fromJson(value);
        update(() {
          if (result.idStatus == 3) {
            oneTimeDrive.removeWhere((e) => e.orderId == result.idOrder);
          } else {
            final order = oneTimeDrive
                .firstWhereOrNull((e) => e.orderId == result.idOrder);
            if (order != null) {
              oneTimeDrive.removeWhere((e) => e.orderId == order.orderId);
            }
            oneTimeDrive.add(result.toUi());
            oneTimeDrive.sort((a, b) => a.isFromSocket ? 0 : 1);
          }
        });
      }
    });
  }

  @override
  Future<bool> loadPage() async {
    var paramRes = await NannyStaticDataApi.getOtherParams();
    if (!paramRes.success) return false;
    for (var e in paramRes.response!) {
      if (!params.any((e) => e.id == e.id)) {
        params.add(e);
      }
    }

    var offerRes =
        await NannyDriverApi.getScheduleRequests(SearchQueryRequest());
    if (!offerRes.success) return false;
    offers = offerRes.response!;
    return true;
  }

  void changeOfferType(OfferType type) => update(() {
        if (type != OfferType.oneTime) {
          selectedId = 0;
        }
        selectedOfferType = type;
      });
}
