import 'dart:convert';

import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/search_query_request.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/api/web_sockets/nanny_web_socket.dart';
import 'package:nanny_core/models/from_api/drive_and_map/driver_schedule_response.dart';
import 'package:nanny_core/models/from_api/drive_and_map/one_time_drive_socket.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_components/widgets/one_time_drive_widget.dart';
import 'package:nanny_driver/views/pages/map/map_view_order.dart';

class OffersVM extends ViewModelBase {
  OffersVM({
    required super.context,
    required super.update,
  }) {
    loadOneTimeDrives();
    initDriveMode();
  }

  var driveToken = '';
  var selectedId = 0;
  OfferType selectedOfferType = OfferType.route;
  List<OneTimeDriveModel> oneTimeDrive = [];
  List<DriverScheduleResponse> offers = [];
  List<OtherParametr> params = [];
  late final NannyWebSocket searchSocket;

  Future<void> loadOneTimeDrives() async {
    final response = await NannyOrdersApi.getOnetimeOrder();
    oneTimeDrive = (response.response ?? []).map((e) => e.toUi()).toList();
    update(() {});
  }

  void setSelected(int orderId) {
    selectedId = orderId;
    update(() {});
  }

  void onCancel() {
    print('on cancel call');
    if (selectedId == 0) return;
    if (oneTimeDrive.any((e) => e.isFromSocket)) {
      var order = oneTimeDrive.firstWhere((e) => e.isFromSocket);
      if (order.orderId == selectedId) {
        searchSocket.channel.sink
            .add('{"id_order": $selectedId, "cancel": True, "type": "order"}');
      }
    } else {
      NannyOrdersApi.declineOrder(selectedId);
    }
  }

  void onAccept() async {
    if (selectedId == 0) return;
    var loc = await LocationService.location.getLocation();
    navigateToView(MapViewOrder(
        myLocation: LatLng(loc.latitude ?? 0, loc.longitude ?? 0),
        model: oneTimeDrive.firstWhere((e) => e.orderId == selectedId),
        driveToken: driveToken,
        orderId: selectedId));
    if (oneTimeDrive.any((e) => e.isFromSocket)) {
      var order = oneTimeDrive.firstWhere((e) => e.isFromSocket);
      if (order.orderId == selectedId) {
        searchSocket.channel.sink
            .add('{"id_order": $selectedId, "accept": True, "type": "order"}');
      }
    } else {
      NannyOrdersApi.acceptOrder(selectedId);
    }
  }

  Future<void> initDriveMode() async {
    var loc = LocationService.curLoc ??
        (await LocationService.location.getLocation());
    NannyDriverApi.startDriveMode(LatLng(loc.latitude ?? 0, loc.longitude ?? 0))
        .then((v) async {
      if (v.success) {
        driveToken = v.response ?? '';
        searchSocket = await OrdersSearchSocket(v.response ?? '').connect();
        initListen();
      }
    });
  }

  void initListen() {
    searchSocket.stream.listen((v) {
      if (v is Map<String, dynamic>) {
        var result = OneTimeDriveResponse.fromJson(v);
        if (oneTimeDrive.any((e) => e.orderId != result.idOrder)) {
          update(() {
            oneTimeDrive.add(result.toUi(isFromSocket: true));
            oneTimeDrive.sort((a, b) => a.isFromSocket ? 0 : 1);
          });
        }
      }
      if (v is String) {
        var result = OneTimeDriveResponse.fromJson(jsonDecode(v));
        if (oneTimeDrive.any((e) => e.orderId != result.idOrder)) {
          update(() {
            oneTimeDrive.add(result.toUi(isFromSocket: true));
            oneTimeDrive.sort((a, b) => a.isFromSocket ? 0 : 1);
          });
        }
      }
    });
  }

  @override
  Future<bool> loadPage() async {
    var paramRes = await NannyStaticDataApi.getOtherParams();
    if (!paramRes.success) return false;

    params = paramRes.response!;

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
        reloadPage();
      });
}
