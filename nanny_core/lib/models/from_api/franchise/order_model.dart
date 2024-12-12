import 'dart:convert';

class OrderModel {
  final int id;
  final String status;
  final String name;
  final int idDriver;
  final String nameDriver;
  final String surnameDriver;

  OrderModel({
    required this.id,
    required this.status,
    required this.name,
    required this.idDriver,
    required this.nameDriver,
    required this.surnameDriver,
  });

  OrderModel copyWith({
    int? id,
    String? status,
    String? name,
    int? idDriver,
    String? nameDriver,
    String? surnameDriver,
  }) =>
      OrderModel(
        id: id ?? this.id,
        status: status ?? this.status,
        name: name ?? this.name,
        idDriver: idDriver ?? this.idDriver,
        nameDriver: nameDriver ?? this.nameDriver,
        surnameDriver: surnameDriver ?? this.surnameDriver,
      );

  factory OrderModel.fromRawJson(String str) =>
      OrderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        status: json["status"],
        name: json["name"],
        idDriver: json["id_driver"],
        nameDriver: json["name_driver"],
        surnameDriver: json["surname_driver"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "name": name,
        "id_driver": idDriver,
        "name_driver": nameDriver,
        "surname_driver": surnameDriver,
      };
}
