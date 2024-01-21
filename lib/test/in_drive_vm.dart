import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/map_services/drive_manager.dart';
import 'package:nanny_core/nanny_core.dart';

class InDriveVM extends ViewModelBase {
  InDriveVM({
    required super.context, 
    required super.update,
    required this.driveManager,
  }) {
    markers.value.add(posMarker);

    // locSub = LocationService.location.onLocationChanged.listen(updateDriveAndPos);
    tapSub = NannyMapGlobals.onMapTap.listen(updateDriveAndPos);

    markers.notifyListeners();
  }

  final DriveManager driveManager;

  ValueNotifier<Set<Marker>> markers = NannyMapGlobals.markers;
  ValueNotifier<Set<Polyline>> routes = NannyMapGlobals.routes;
  
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
  
  // late StreamSubscription<LocationData> locSub;
  late StreamSubscription<LatLng> tapSub;

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

  void updateDriveAndPos(LatLng loc) {
    lastLoc ??= loc;

    curLoc = loc;
  
    var pos = NannyMapUtils.filterMovement(
      curLoc!, 
      lastLoc!,
    );

  
    var upd = driveManager.updateDriveRoute(pos);
    posMarker = posMarker.copyWith(positionParam: upd);

    lastLoc = pos;

    // routes.value.clear();
    // routes.value = {updateResult.route};
    // routes.notifyListeners();

    markers.value.clear();
    markers.value = {posMarker};
    markers.notifyListeners();
  }
}
