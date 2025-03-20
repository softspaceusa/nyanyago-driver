class OnetimeOrderResponseModel {
  OnetimeOrderResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.idOrder,
    required this.time,
    required this.addresses,
    required this.totalPrice,
    required this.totalDistanceMeters,
    required this.totalDurationSecondsEstimated,
  });

  final bool status;
  final String message;
  final String token;
  final int idOrder;
  final double time;
  final List<OrderAddress> addresses;
  final double totalPrice;
  final double totalDistanceMeters;
  final double totalDurationSecondsEstimated;

  factory OnetimeOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OnetimeOrderResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      idOrder: json['id_order'] ?? 0,
      time: double.tryParse(json['time'].toString()) ?? 0.0,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => OrderAddress.fromJson(e))
              .toList() ??
          [],
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      totalDistanceMeters:
          (json['total_distance_meters'] as num?)?.toDouble() ?? 0.0,
      totalDurationSecondsEstimated:
          (json['total_duration_seconds_estimated'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OrderAddress {
  OrderAddress({
    required this.fromAddress,
    required this.toAddress,
    required this.fromLat,
    required this.fromLon,
    required this.toLat,
    required this.toLon,
  });

  final String fromAddress;
  final String toAddress;
  final double fromLat;
  final double fromLon;
  final double toLat;
  final double toLon;

  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    return OrderAddress(
      fromAddress: json['from_address'] ?? '',
      toAddress: json['to_address'] ?? '',
      fromLat: (json['from_lat'] as num?)?.toDouble() ?? 0.0,
      fromLon: (json['from_lon'] as num?)?.toDouble() ?? 0.0,
      toLat: (json['to_lat'] as num?)?.toDouble() ?? 0.0,
      toLon: (json['to_lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
