import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/map_services/drive_manager.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/test/drive_complete.dart';

class InDriveVM extends ViewModelBase {
  InDriveVM({
    required super.context, 
    required super.update,
    required this.driveManager,
  }) {
    markers.value.add(posMarker);

    // locSub = LocationService.location.onLocationChanged.listen(updateDriveAndPos);
    // tapSub = NannyMapGlobals.onMapTap.listen((loc) {
    //   if(driveManager.getDistanceToFirstPoint(loc) > 500) {
    //     driveManager.redrawRoute(loc);
    //     return;
    //   }
    //   updateDriveAndPos(loc);
    // });
    locSub = Timer.periodic(const Duration(seconds: 1), (timer) => driveSubUpdate());
    sumDistance = RouteManager.meters2Kilometers( RouteManager.computeDistance(driveManager.currentRoute) );

    markers.notifyListeners();
  }

  final DriveManager driveManager;

  ValueNotifier<Set<Marker>> markers = NannyMapGlobals.markers;
  ValueNotifier<Set<Polyline>> routes = NannyMapGlobals.routes;

  bool atEnd = false;
  
  LatLng? curLoc;
  LatLng? lastLoc;
  Marker posMarker = Marker(
    consumeTapEvents: true,
    flat: true,

    markerId: NannyConsts.driverPosId,
    icon: NannyConsts.driverPosIcon,
    anchor: const Offset(0.5, 0.5),
    position: NannyMapUtils.locData2LatLng(LocationService.curLoc),
  );
  double distanceLeft = 0;
  late double sumDistance;

  double get drivePercent => 1 - distanceLeft / sumDistance;
  
  // late StreamSubscription<LatLng> tapSub;
  late Timer locSub;

  // void updateDriveAndPos(LocationData loc) {
  //   if(lastLoc == null) {
  //     lastLoc = loc;
  //   }
  //   else {
  //     lastLoc = curLoc;
  //   }
  //   curLoc = loc;
  
  //   var pos = NannyMapUtils.filterMovement(
  //     NannyMapUtils.locData2LatLng(curLoc!), 
  //     NannyMapUtils.locData2LatLng(lastLoc!)
  //   );
  
  //   posMarker = posMarker.copyWith(positionParam: pos);
  //   markers.notifyListeners();
  // }

  void driveSubUpdate() async {
    var loc = await LocationService.location.getLocation();
    var pos = NannyMapUtils.locData2LatLng(loc);
    if(driveManager.getDistanceToFirstPoint(pos) > 100) {
      driveManager.redrawRoute(pos);
      return;
    }
    updateDriveAndPos(pos);
  }

  void updateDriveAndPos(LatLng loc) {
    lastLoc ??= loc;

    curLoc = loc;
  
    var pos = NannyMapUtils.filterMovement(
      curLoc!, 
      lastLoc!,
    );

    var upd = driveManager.updateDriveRoute(pos);
    double heading = driveManager.getHeading(lastLoc!, curLoc!);
    posMarker = posMarker.copyWith(
      positionParam: upd.loc,
      rotationParam: upd.heading ?? heading,
    );

    Logger().i(upd.heading ?? heading);

    lastLoc = upd.loc;

    routes.value.clear();
    routes.value = {upd.route};
    routes.notifyListeners();

    markers.value.clear();
    markers.value = {posMarker};
    markers.notifyListeners();

    distanceLeft = RouteManager.meters2Kilometers( RouteManager.computeDistance(upd.route) );
    if(!atEnd) atEnd = driveManager.isAtRouteEnd(upd.loc);

    update(() {});
  }

  void endDrive() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const DriveCompleteView())
    );
    dispose();
  }

  void dispose() {
    // tapSub.cancel();
    locSub.cancel();
  }
}
