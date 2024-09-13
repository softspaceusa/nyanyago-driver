import 'package:nanny_components/widgets/one_time_drive_widget.dart';

class OneTimeDriveResponse {
  final int? idOrder;
  final String? username;
  final String? phone;
  final String? userPhoto;
  final double? amount;
  final int? idStatus;
  final List<AddressOneTimeDrive>? addresses;

  OneTimeDriveResponse(
      {this.idOrder,
      this.username,
      this.phone,
      this.userPhoto,
      this.amount,
      this.idStatus,
      this.addresses});

  factory OneTimeDriveResponse.fromJson(Map<String, dynamic> json) {
    return OneTimeDriveResponse(
        idOrder: json['id_order'],
        username: json['username'],
        phone: json['phone'],
        userPhoto: json['user_photo'],
        amount: json['amount'],
        idStatus: json['id_status'],
        addresses: (json['addresses'] as List?)
            ?.map((e) => AddressOneTimeDrive.fromJson(e))
            .toList());
  }

  OneTimeDriveModel toUi({bool isFromSocket = false}) => OneTimeDriveModel(
      avatar: userPhoto ?? '',
      username: username ?? '',
      isFromSocket: isFromSocket,
      price: (amount ?? 0).toString(),
      orderId: idOrder ?? 0,
      orderStatus: idStatus ?? 0,
      addresses: addresses?.map((e) => e.toUI()).toList() ?? []);
}

class AddressOneTimeDrive {
  final String? from;
  final bool? isFinish;
  final String? to;
  final double? fromLat;
  final double? fromLon;
  final double? toLat;
  final double? toLon;
  final int? duration;

  AddressOneTimeDrive(
      {this.from,
      this.isFinish,
      this.to,
      this.fromLat,
      this.fromLon,
      this.toLat,
      this.toLon,
      this.duration});

  factory AddressOneTimeDrive.fromJson(Map<String, dynamic> json) {
    return AddressOneTimeDrive(
        from: json['from'],
        isFinish: json['is_finish'],
        to: json['to'],
        fromLat: json['from_lat'],
        fromLon: json['from_lon'],
        toLat: json['to_lat'],
        toLon: json['to_lon'],
        duration: json['duration']);
  }

  OneTimeDriveAddress toUI() => OneTimeDriveAddress(
      from: from ?? '',
      isFinish: isFinish ?? false,
      to: to ?? '',
      fromLat: fromLat ?? 0,
      fromLon: fromLon ?? 0,
      toLat: toLat ?? 0,
      toLon: toLon ?? 0,
      duration: duration ?? 0);
}
