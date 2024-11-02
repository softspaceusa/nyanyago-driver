import 'dart:math';

import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/geocoding_data.dart';
import 'package:nanny_core/nanny_core.dart';

class NannyMapUtils {
  static Point locData2Point(LocationData loc) =>
      Point(loc.longitude!, loc.latitude!);

  static Point latLng2Point(LatLng loc) => Point(loc.longitude, loc.latitude);

  static LatLng point2LatLng(Point p) => LatLng(p.y.toDouble(), p.x.toDouble());

  static List<Point> polyline2Points(Polyline route) =>
      route.points.map((e) => Point(e.longitude, e.latitude)).toList();

  static LatLng locData2LatLng(LocationData loc) =>
      LatLng(loc.latitude!, loc.longitude!);

  static LatLng filterMovement(LatLng curPos, LatLng lastPos,
      {double k = 0.5}) {
    assert(k <= 1 && k >= 0);

    double lat = simpleKalmanFilter(k, curPos.latitude, lastPos.latitude);
    double lng = simpleKalmanFilter(k, curPos.longitude, lastPos.longitude);

    return LatLng(lat, lng);
  }

  static double calculateDistance(LatLng start, LatLng end) {
    const earthRadius = 6371000; // Радиус Земли в метрах

    double dLat = _toRadians(end.latitude - start.latitude);
    double dLon = _toRadians(end.longitude - start.longitude);

    double lat1 = _toRadians(start.latitude);
    double lat2 = _toRadians(end.latitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  static LatLng findClosestPoint(
      LatLng currentPosition, List<LatLng> polylinePoints) {
    LatLng? closestPoint;
    double minDistance = double.infinity;

    for (LatLng point in polylinePoints) {
      double distance = calculateDistance(currentPosition, point);
      if (distance < minDistance) {
        minDistance = distance;
        closestPoint = point;
      }
    }

    return closestPoint ?? currentPosition;
  }

  static List<LatLng> getRemainingPoints(
      LatLng currentPosition, List<LatLng> polylinePoints) {
    LatLng closestPoint = findClosestPoint(currentPosition, polylinePoints);
    int closestIndex = polylinePoints.indexOf(closestPoint);
    return polylinePoints.isNotEmpty
        ? polylinePoints.sublist(closestIndex)
        : [];
  }

  static List<LatLng> findRemainingRoute(
      List<LatLng> polylinePoints, LatLng currentPosition) {
    List<LatLng> remainingPoints =
        getRemainingPoints(currentPosition, polylinePoints);
    return remainingPoints;
  }

  static double haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance * 1000;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  static GeocodeFormatResult filterGeocodeData(GeocodeData data) {
    var addresses = data.geocodeResults
        .where((e) => e.types.contains(AddressType.streetAddress));

    if (addresses.isEmpty) {
      return GeocodeFormatResult(
        address: addresses.first,
        simplifiedAddress: addresses.first.formattedAddress,
      );
    }

    GeocodeResult address = addresses.first;
    String formatedAddress = simplifyAddress(address.formattedAddress);

    return GeocodeFormatResult(
        address: address, simplifiedAddress: formatedAddress);
  }

  static String simplifyAddress(String address) {
    List<String> addressParts = address.split(', ');

    if (addressParts.isEmpty) return address;

    if (addressParts.length > 2) {
      return "${addressParts[0]}, ${addressParts[1]}, ${addressParts[2]}";
    }
    if (addressParts.length > 1) {
      return "${addressParts[0]}, ${addressParts[1]}";
    }

    return addressParts.first;
  }

  static double simpleKalmanFilter(
      double k, double curValue, double lastValue) {
    assert(k <= 1 && k >= 0);

    return k * curValue + (1 - k) * lastValue;
  }
}

/// Result of [NannyMapUtils.filterGeocodeData]
class GeocodeFormatResult {
  GeocodeFormatResult({required this.address, required this.simplifiedAddress});

  final GeocodeResult address;
  final String simplifiedAddress;
}
