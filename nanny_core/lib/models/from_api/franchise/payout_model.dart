import 'dart:convert';

class PayoutModel {
  final int id;
  final int money;
  final String datetimeCreate;
  final int cashbackPercent;

  PayoutModel({
    required this.id,
    required this.money,
    required this.datetimeCreate,
    required this.cashbackPercent,
  });

  PayoutModel copyWith({
    int? id,
    int? money,
    String? datetimeCreate,
    int? cashbackPercent,
  }) =>
      PayoutModel(
        id: id ?? this.id,
        money: money ?? this.money,
        datetimeCreate: datetimeCreate ?? this.datetimeCreate,
        cashbackPercent: cashbackPercent ?? this.cashbackPercent,
      );

  factory PayoutModel.fromRawJson(String str) =>
      PayoutModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PayoutModel.fromJson(Map<String, dynamic> json) => PayoutModel(
        id: json["id"],
        money: json["money"],
        datetimeCreate: json["datetime_create"],
        cashbackPercent: json["cashback_percent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "money": money,
        "datetime_create": datetimeCreate,
        "cashback_percent": cashbackPercent,
      };
}
