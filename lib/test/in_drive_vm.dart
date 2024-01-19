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

    locSub = LocationService.location.onLocationChanged.listen((loc) {
      if(lastLoc == null) {
        lastLoc = loc;
      }
      else {
        lastLoc = curLoc;
      }
      curLoc = loc;

      var pos = NannyMapUtils.filterMovement(
        NannyMapUtils.locData2LatLng(curLoc!), 
        NannyMapUtils.locData2LatLng(lastLoc!)
      );

      posMarker = posMarker.copyWith(positionParam: pos);
      markers.notifyListeners();
    });

    markers.notifyListeners();
  }

  final DriveManager driveManager;

  ValueNotifier<Set<Marker>> markers = NannyMapGlobals.markers;
  LocationData? curLoc;
  LocationData? lastLoc;
  Marker posMarker = Marker(
    markerId: NannyConsts.driverPosId,
    icon: NannyConsts.curPosIcon,
    position: NannyMapUtils.locData2LatLng(LocationService.curLoc),
  );
  
  late StreamSubscription<LocationData> locSub;
}