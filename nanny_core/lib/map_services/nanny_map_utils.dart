import 'dart:math';

import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/geocoding_data.dart';
import 'package:nanny_core/nanny_core.dart';

class NannyMapUtils {
  static Point locData2Point(LocationData loc) => Point(loc.longitude!, loc.latitude!);
  static Point latLng2Point(LatLng loc) => Point(loc.longitude, loc.latitude);
  static LatLng point2LatLng(Point p) =>LatLng(p.y.toDouble(), p.x.toDouble());
  static List<Point> polyline2Points(Polyline route) => route.points
    .map((e) => Point(e.longitude, e.latitude))
    .toList();
  
  static LatLng locData2LatLng(LocationData loc) => LatLng(loc.latitude!, loc.longitude!);

  static LatLng filterMovement(LatLng curPos, LatLng lastPos, {double k = 0.5}) {
    assert(k <= 1 && k >= 0);

    double lat = simpleKalmanFilter(k, curPos.latitude, lastPos.latitude);
    double lng = simpleKalmanFilter(k, curPos.longitude, lastPos.longitude);

    return LatLng(lat, lng);
  }

  static GeocodeFormatResult filterGeocodeData(GeocodeData data) {
    var addresses = data.geocodeResults.where(
      (e) => e.types.contains(AddressType.streetAddress)
    );

    if(addresses.isEmpty) {
        return GeocodeFormatResult(
        address: addresses.first, 
        simplifiedAddress: addresses.first.formattedAddress,
      );
    }

    GeocodeResult address = addresses.first;
    String formatedAddress = simplifyAddress(address.formattedAddress);

    return GeocodeFormatResult(
      address: address, 
      simplifiedAddress: formatedAddress
    );
  }

  static String simplifyAddress(String address) {
    List<String> addressParts = address.split(', ');

    if(addressParts.isEmpty) return address;

    if(addressParts.length > 2) { 
      return "${addressParts[0]}, ${addressParts[1]}, ${addressParts[2]}";
    }
    if(addressParts.length > 1) { 
      return "${addressParts[0]}, ${addressParts[1]}";
    }

    return addressParts.first;
  }

  /// [k] 0 <= n <= 1
  static double simpleKalmanFilter(double k, double curValue, double lastValue) {
    assert(k <= 1 && k >= 0);

    return k * curValue + (1 - k) * lastValue;
  }
}

/// Result of [NannyMapUtils.filterGeocodeData]
class GeocodeFormatResult {
  GeocodeFormatResult({
    required this.address,
    required this.simplifiedAddress
  });

  final GeocodeResult address;
  final String simplifiedAddress;
}