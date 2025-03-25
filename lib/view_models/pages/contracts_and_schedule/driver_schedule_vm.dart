import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/one_time_drive_widget.dart';
import 'package:nanny_core/api/api_models/onetime_drive_request.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/models/from_api/chat_message.dart';
import 'package:nanny_core/models/from_api/drive_and_map/address_data.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/drive_and_map/driver_schedule_response.dart';
import 'package:nanny_core/models/from_api/drive_and_map/onetime_order_response_model.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/models/from_api/drive_and_map/today_schedule_data.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/providers/bloc/socket_bloc.dart';
import 'package:nanny_driver/views/pages/map/map_view_order.dart';

class DriverScheduleVM extends ViewModelBase {
  DriverScheduleVM({required super.context, required super.update});

  List<TodayScheduleData> schedules = [];
  double distance = 0;
  double duration = 0;
  List<DriveTariff> tariffs = [];
  int? selectedId;

  void selectRoad(int? id) => update(() {
        if (selectedId == id) {
          selectedId = null; // Сбрасываем, если уже выбрано
        } else {
          selectedId = id; // Устанавливаем новое значение
        }
      });

  void startOrder(int roaId) async {
    LoadScreen.showLoad(context, true);

    var scheduleReq = await NannyDriverApi.getFullRoadsInfo('$roaId');

    if (!scheduleReq.success ||
        scheduleReq.response == null ||
        scheduleReq.response!.isEmpty) {
      NannyDialogs.showMessageBox(
          context, "Ошибка!", "Не удалось получить данные маршрута.");
      LoadScreen.showLoad(context, false);
      return;
    }

    List<DriverScheduleResponse>? schedules = scheduleReq.response;

    DriverScheduleResponse? schedule = (schedules ?? [])
        .firstWhereOrNull((e) => e.roads.any((e) => e.id == roaId));

    if (schedule == null) {
      NannyDialogs.showMessageBox(context, "Ошибка!", "Маршрут не найден.");
      LoadScreen.showLoad(context, false);
      return;
    }

    tariffs = (await NannyStaticDataApi.getTariffs()).response ?? [];
    if (tariffs.isEmpty) {
      NannyDialogs.showMessageBox(
          context, "Ошибка!", "Не удалось загрузить тарифы.");
      LoadScreen.showLoad(context, false);
      return;
    }

    DriveTariff? tariff =
        tariffs.firstWhereOrNull((e) => e.id == schedule.tariff.id);
    if (tariff == null || tariff.amount == null) {
      NannyDialogs.showMessageBox(
          context, "Ошибка!", "Не найден соответствующий тариф.");
      LoadScreen.showLoad(context, false);
      return;
    }

    Road? road = schedule.roads.firstWhereOrNull((e) => e.id == roaId);
    if (road == null || road.addresses.isEmpty) {
      NannyDialogs.showMessageBox(
          context, "Ошибка!", "Маршрут не содержит адресов.");
      LoadScreen.showLoad(context, false);
      return;
    }

    await calculatePrices(
        [road.addresses.first.fromAddress, road.addresses.last.toAddress]);

    var curLoc = LocationService.curLoc;
    if (curLoc == null) {
      await LocationService.location.getLocation().then((v) {
        curLoc = v;
        LocationService.curLoc = v;
        print('current location $curLoc');
      });
    }

    if (curLoc == null) {
      NannyDialogs.showMessageBox(
          context, "Ошибка!", "Не удалось получить текущую локацию.");
      LoadScreen.showLoad(context, false);
      return;
    }

    var createOrderRes = await DioRequest.handle(
      context,
      NannyOrdersApi.startOnetimeOrder(
        OnetimeDriveRequest(
          myLocation: LocationService.curLoc,
          addresses: road.addresses,
          price: tariff.amount!.toInt(),
          distance: distance.ceil(),
          duration: duration.ceil(),
          description: schedule.description,
          typeDrive: road.typeDrive.first.id,
          idTariff: schedule.tariff.id,
          otherParametrs: schedule.otherParametrs
              .map(
                (e) => {'parametr': e.id, 'count': 1},
              )
              .toList(),
        ),
      ),
    );

    if (!createOrderRes.success || scheduleReq.response == null) {
      NannyDialogs.showMessageBox(
          context, "Ошибка!", "Не удалось создать заказ.");
      LoadScreen.showLoad(context, false);
      return;
    }

    OnetimeOrderResponseModel order = createOrderRes.data!;

    NannyGlobals.chatsSocket.sink?.add(
      jsonEncode(
        ChatMessage(
            idChat: 1,
            msg: order.token,
            msgType: 5,
            timestampSend: 0,
            isMe: true),
      ),
    );

    await DioRequest.handle(
      context,
      NannyOrdersApi.acceptOrder(order.idOrder),
    );

    LoadScreen.showLoad(context, false);

    selectRoad(null);

    await navigateToView(
      MapViewOrder(
          myLocation: LatLng(curLoc?.latitude ?? 0, curLoc?.longitude ?? 0),
          model: OneTimeDriveModel(
            avatar: '',
            username: '',
            price: order.totalPrice.toString(),
            orderId: order.idOrder,
            orderStatus: 13,
            addresses: order.addresses
                .map(
                  (e) => OneTimeDriveAddress(
                    from: e.fromAddress,
                    isFinish: true,
                    to: e.toAddress,
                    fromLat: e.fromLat,
                    fromLon: e.fromLon,
                    toLat: e.toLat,
                    toLon: e.toLon,
                    duration: duration.ceil(),
                  ),
                )
                .toList(),
          ),
          searchSocket: context.read<SocketBloc>().searchSocket,
          orderId: order.idOrder),
    );
  }

  Future calculatePrices(List<AddressData> addresses) async {
    LoadScreen.showLoad(context, true);

    NannyMapGlobals.routes.value.clear();
    distance = 0;
    duration = 0;
    for (int i = 0; i < addresses.length - 1; i++) {
      var origin = addresses[i].location;
      var dest = addresses[i + 1].location;

      var polyRes = await PolylinePoints().getRouteBetweenCoordinates(
        NannyConsts.mapKey,
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(dest.latitude, dest.longitude),
      );

      distance += SphericalUtils.computeDistanceBetween(
          Point(origin.longitude, origin.latitude),
          Point(dest.longitude, dest.latitude));
      duration += polyRes.durationValue!;

      var route = await RouteManager.calculateRoute(
          origin: origin, destination: dest, id: "route_$i");

      if (route == null) continue;

      NannyMapGlobals.routes.value.add(route);
    }

    distance /= 1000;
    duration /= 60;

    var res = await DioRequest.handle(context,
        NannyOrdersApi.getOnetimePrices(duration.ceil(), distance.ceil()));

    if (!res.success) {
      NannyDialogs.showMessageBox(
          context, "Ошибка!", "Не удалось получить цены.");
      LoadScreen.showLoad(context, false);
      return;
    }

    var priceTars = res.data!;
    for (var tar in tariffs) {
      var tariff = priceTars.where((e) => e.id == tar.id).firstOrNull;
      if (tariff == null) continue;

      tar.amount = tariff.amount!;
    }
    LoadScreen.showLoad(context, false);
    update(() {});
  }

  @override
  Future<bool> loadPage() async {
    var schedRes = await NannyDriverApi.getTodaySchedules();
    if (!schedRes.success) return false;

    schedules = schedRes.response ?? [];

    /*schedules = List.generate(
        10,
        (index) => TodayScheduleData(
            id: 55,
            title: 'Schedule index',
            parentName: 'Parent index',
            idParent: index,
            time: '12:00 - 15:00',
            date: DateTime.now())).toList();*/

    return true;
  }
}
