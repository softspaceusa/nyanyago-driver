import 'dart:async';

import 'package:location/location.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/google_map_api.dart';
import 'package:nanny_core/map_services/nanny_map_utils.dart';

class LocationService {
  static final Location location = Location();
  static LocationData? curLoc;
  static StreamSubscription? _locSub;
  static GeocodeFormatResult? lastLocationInfo;

  static void initBackgroundLocation() async {
    await location.requestPermission();
    await location.requestService();
    await location.enableBackgroundMode(enable: true);
    _locSub = location.onLocationChanged.listen((loc) => curLoc = loc);
  }

  static Future<GeocodeFormatResult?> getLocationInfo(LatLng latLng) async {
    var data = await GoogleMapApi.reverseGeocode(loc: latLng);

    if(!data.success) return null;
    return NannyMapUtils.filterGeocodeData(data.response!);
  }

  static Future<void> initLocInfo() async => lastLocationInfo = await getLocationInfo(
    NannyMapUtils.locData2LatLng( await location.getLocation() )
  );

  static void dispose() {
    _locSub?.cancel();
    location.enableBackgroundMode(enable: false);
  }
}