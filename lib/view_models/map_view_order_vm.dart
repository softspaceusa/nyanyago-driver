import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/one_time_drive_widget.dart';

import 'package:nanny_core/api/web_sockets/nanny_web_socket.dart';
import 'package:nanny_core/map_services/drive_manager.dart';
import 'package:nanny_core/nanny_core.dart';

class MapViewOrderVm extends ViewModelBase {
  final String driveToken;
  final OneTimeDriveModel oneTimeDriveModel;
  late NannyWebSocket searchSocket;
  var currentState = StatusValue.driverSearch;
  int currentTimeWait = 0;
  DriveManager? driveManager;
  late final StreamSubscription<LocationData> locChange;
  ValueNotifier<Set<Marker>> markers = NannyMapGlobals.markers;
  ValueNotifier<Set<Polyline>> routes = NannyMapGlobals.routes;
  final ValueNotifier<Set<Marker>> mapMarkers = NannyMapGlobals.markers;
  bool atEnd = false;
  LatLng? curLoc;
  LocationData? lastLoc;
  late GoogleMapController controller;
  bool calculating = false;

  MapViewOrderVm(
      {required super.context,
      required super.update,
      required this.oneTimeDriveModel,
      required this.driveToken}) {
    setChangeLocation();
    initSocket();
    NannyDriverApi.getClientToken().then((value) {
      print('token of client ${value.response}');
    });
  }

  late Marker curPos;
  List<Polyline> polylines = [];
  Marker? posMarker = LocationService.curLoc != null
      ? Marker(
          consumeTapEvents: true,
          flat: true,
          markerId: NannyConsts.driverPosId,
          icon: NannyConsts.driverPosIcon,
          anchor: const Offset(0.5, 0.5),
          position: NannyMapUtils.locData2LatLng(LocationService.curLoc!))
      : null;
  Timer? checkAtLocationTimer;
  Timer? timerAwait;

  void initController(GoogleMapController controller) =>
      this.controller = controller;

  void moveCameraToMe(LatLng target) => controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 15)));

  Future<void> initSocket() async {
    searchSocket = await OrdersSearchSocket(driveToken).connect();
    onStatusChange(StatusValue.driverFound);
    await calculatePolylinesArrive();
    initListen();
  }

  void initListen() {
    searchSocket.stream.listen((v) {
      print('incoming value driver $v');
    });
  }

  String get getMinutes {
    var v = currentTimeWait ~/ 60;
    if (v >= 10) {
      return '$v';
    } else {
      return '0$v';
    }
  }

  double distanceToEnd = 0;
  double currentDistance = 0;

  String get getSeconds {
    var v = currentTimeWait % 60;
    if (v >= 10) {
      return '$v';
    } else {
      return '0$v';
    }
  }

  int timeToArrive = 0;
  Timer? timerSinkLocation;

  int get timeToArriveMinutes => timeToArrive ~/ 60;
  PolylineResult? arriveTo;

  void setChangeLocation() {
    locChange = LocationService.location.onLocationChanged.listen((loc) {
      curPos = Marker(
          markerId: NannyConsts.curPosId,
          icon: NannyConsts.curPosIcon,
          anchor: const Offset(.5, .5),
          position: NannyMapUtils.locData2LatLng(loc));
      var position = NannyMapUtils.locData2LatLng(loc);
      mapMarkers.value
          .removeWhere((e) => e.markerId.value == NannyConsts.curPosId.value);
      markers.value.remove(curPos);
      curPos = curPos.copyWith(positionParam: position);
      lastLoc ??= loc;
      var newLoc = NannyMapUtils.filterMovement(
          NannyMapUtils.locData2LatLng(loc),
          NannyMapUtils.locData2LatLng(lastLoc!));
      try {
        calculatedTime(position);
      } catch (e) {
        print('$e');
      }

      moveCameraToMe(curPos.position);

      mapMarkers.value.add(curPos);
      if (context.mounted) update(() {});
    });
  }

  Future<void> sendLocationDuration(LatLng loc) async {
    var lat = loc.latitude;
    var lon = loc.longitude;
    if (timeToArrive == 0) timeToArrive = 1;
    searchSocket.sinkValue({'lat': lat, 'lon': lon, 'duration': timeToArrive});
    var destination = oneTimeDriveModel.addresses;
    if (destination.isNotEmpty) {
      var firstDestination = destination.first;
      var lat1 = loc.latitude;
      var lon1 = loc.longitude;
      var lat2 = firstDestination.toLat;
      var lon2 = firstDestination.toLon;
      var haversine = NannyMapUtils.haversineDistance(lat1, lon1, lat2, lon2);
      if (haversine < 100) {
        if (currentState == StatusValue.onWay) {
          onStatusChange(StatusValue.onPlace);
        } else {
          onStatusChange(StatusValue.arrived);
        }
      }
    }
  }

  Future<void> onStatusChange(StatusValue status) async {
    if (context.mounted) {
      update(() {
        currentState = status;
      });
    }
    if (!searchSocket.connected) {
      searchSocket = await OrdersSearchSocket(driveToken).connect();
    }
    searchSocket.sinkValue(
        {'id_order': oneTimeDriveModel.orderId, 'status': status.id});
    switch (status) {
      case StatusValue.canceledByDriver:
        break;
      case StatusValue.onWay:
        break;
      case StatusValue.awaiting:
        timerAwait?.cancel();
        timerAwait = null;
        checkAtLocationTimer?.cancel();
        checkAtLocationTimer = null;
        await calculatePolylinesDrive();
        timerAwait = Timer.periodic(const Duration(seconds: 1), (timer) async {
          currentTimeWait++;
          if (context.mounted) {
            update(() {});
          }
        });
        break;
      case StatusValue.complete:
        checkAtLocationTimer?.cancel();
        checkAtLocationTimer = null;
        timerAwait?.cancel();
        timerAwait = null;
        if (status.id == 11) popView();
        break;
      case StatusValue.driveStarted:
        checkAtLocationTimer?.cancel();
        checkAtLocationTimer = null;
        checkAtLocationTimer =
            Timer.periodic(const Duration(seconds: 5), (timer) async {
          var loc = await LocationService.location.getLocation();
          var lat = loc.latitude ?? 0.0;
          var lon = loc.longitude ?? 0.0;
          if (context.mounted) {
            sendLocationDuration(LatLng(lat, lon));
          }
        });
        break;
      case StatusValue.arrived:
        checkAtLocationTimer?.cancel();
        checkAtLocationTimer = null;
        var loc = await LocationService.location.getLocation();
        var lat = loc.latitude ?? 0.0;
        var lon = loc.longitude ?? 0.0;
        sendLocationDuration(LatLng(lat, lon));
        break;
      case StatusValue.driverFound:
        var location = await LocationService.location.getLocation();
        var lat = location.latitude ?? 0.0;
        var lon = location.longitude ?? 0.0;
        searchSocket.sinkValue({'lat': lat, 'lon': lon});
        break;
      default:
        timerAwait?.cancel();
        timerAwait = null;
        break;
    }
  }

  Future<void> calculatePolylinesArrive() async {
    var myLoc = await LocationService.location.getLocation();
    var dest = oneTimeDriveModel.addresses.first;
    var pos = LatLng(myLoc.latitude ?? 0, myLoc.longitude ?? 0);
    var polyline = await RouteManager.getResults(
        origin: pos, destination: LatLng(dest.fromLat, dest.fromLon));
    arriveTo = polyline;
    getPolylines(
        polyline.points.map((e) => LatLng(e.latitude, e.longitude)).toList());
    timeToArrive = polyline.durationValue ?? 0;
    distanceToEnd = (polyline.distanceValue ?? 0).toDouble();
    calculatedTime(pos);
    update(() {});
  }

  Future<void> calculatePolylinesDrive() async {
    var loc = await LocationService.location.getLocation();
    var lat = loc.latitude ?? 0.0;
    var lon = loc.longitude ?? 0.0;
    await Future.forEach(oneTimeDriveModel.addresses, (address) async {
      var polyline = await RouteManager.getResults(
          origin: LatLng(address.fromLat, address.fromLon),
          destination: LatLng(address.toLat, address.toLon));
      arriveTo = polyline;
      var points = arriveTo?.points ?? [];
      var pointsToArrive = NannyMapUtils.findRemainingRoute(
          points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
          LatLng(lat, lon));
      if (pointsToArrive.isNotEmpty) {
        pointsToArrive.removeAt(0);
        pointsToArrive.insert(0, LatLng(lat, lon));
      }

      var distance = calculateTotalDistance(
          points.map((e) => LatLng(e.latitude, e.longitude)).toList());
      var distanceToArrive = calculateTotalDistance(
          pointsToArrive.map((e) => LatLng(e.latitude, e.longitude)).toList());
      distanceToEnd = (polyline.distanceValue ?? 0).toDouble();
      currentDistance = 1 - (distanceToArrive / distance);
      print('distance to end ${distanceToEnd}');
      getPolylines(
          polyline.points.map((e) => LatLng(e.latitude, e.longitude)).toList());
      timeToArrive = polyline.durationValue ?? 0;
      searchSocket
          .sinkValue({'lat': lat, 'lon': lon, 'duration': timeToArrive});
    });
    update(() {});
  }

  void getPolylines(List<LatLng> points, {String? id}) async {
    polylines.add(Polyline(
        polylineId: PolylineId(id ?? 'route'),
        points: points,
        color: NannyTheme.primary));
    NannyMapGlobals.routes.value = polylines.toSet();
  }

  // 9518656765

  // 9262713209 клиент
  Future<void> onRideStart() async {
    await onStatusChange(StatusValue.onWay);
    if (!searchSocket.connected) {
      await searchSocket.sink.close();
      searchSocket = await OrdersSearchSocket(driveToken).connect();
    }
    checkAtLocationTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      var currentLocation = await LocationService.location.getLocation();
      var destination = oneTimeDriveModel.addresses;
      if (destination.isNotEmpty) {
        var firstDestination = destination.first;
        var lat1 = currentLocation.latitude ?? 0.0;
        var lon1 = currentLocation.longitude ?? 0.0;
        var lat2 = firstDestination.fromLat;
        var lon2 = firstDestination.fromLon;
        var haversine = NannyMapUtils.haversineDistance(lat1, lon1, lat2, lon2);
        if (haversine < 100) {
          update(() {
            if (currentState != StatusValue.onPlace) {
              currentState = StatusValue.onPlace;
              onStatusChange(currentState);
            }
          });
        }
      }
    });
  }

  Future<LatLng> calculatedTime(LatLng currentPosition) async {
    calculating = true;

    var time = arriveTo?.durationValue ?? 0;
    var points = arriveTo?.points ?? [];
    var pointsToArrive = NannyMapUtils.findRemainingRoute(
        points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
        currentPosition);
    if (pointsToArrive.isNotEmpty) {
      pointsToArrive.removeAt(0);
      pointsToArrive.insert(0, currentPosition);
    }

    var distance = calculateTotalDistance(
        points.map((e) => LatLng(e.latitude, e.longitude)).toList());
    var distanceToArrive = calculateTotalDistance(
        pointsToArrive.map((e) => LatLng(e.latitude, e.longitude)).toList());
    polylines.clear();
    getPolylines(
        pointsToArrive.map((e) => LatLng(e.latitude, e.longitude)).toList());
    if (context.mounted) {
      update(() {
        currentDistance = 1 - (distanceToArrive / distance);
        var result = (distanceToArrive / distance * time);
        timeToArrive =
            result.isNaN ? 0 : (distanceToArrive / distance * time).ceil();
      });
    }

    calculating = false;
    return currentPosition;
  }

  double calculateDistance(LatLng start, LatLng end) {
    const earthRadius = 6371000;

    double dLat = _toRadians(end.latitude - start.latitude);
    double dLon = _toRadians(end.longitude - start.longitude);

    double lat1 = _toRadians(start.latitude);
    double lat2 = _toRadians(end.latitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  double calculateTotalDistance(List<LatLng> polylinePoints) {
    double totalDistance = 0.0;
    for (int i = 0; i < polylinePoints.length - 1; i++) {
      totalDistance +=
          calculateDistance(polylinePoints[i], polylinePoints[i + 1]);
    }
    return totalDistance;
  }

  Future<void> onDecline() async {}
}

enum StatusValue {
  created("Создан", 1),
  canceledByUser("Отменен пользователем", 3),
  driverSearch("Поиск водителя", 4),
  onWay("Водитель в пути", 5),
  awaiting("Ожидание", 6),
  onPlace("На месте", 7),
  incident("Авария", 8),
  extremeIncident("Чрезвычайная ситуация", 9),
  sickChild("Ребенку плохо", 10),
  complete("Завершен", 11),
  intermediatePoint("В промежуточной точке", 12),
  driverFound("Водитель найден", 13),
  driveStarted("Водитель начал поездку", 14),
  arrived("Прибыл", 15),
  canceledByDriver("Отменен водителем", 2);

  final String value;
  final int id;

  const StatusValue(this.value, this.id);
}
