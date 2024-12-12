class DriveTariff {
  DriveTariff({
    required this.id,
    this.title,
    this.photoPath,
    this.type,
    this.amount,
    this.isAvailable = false,
    this.oneTime = false,
  });

  final int id;
  final String? title;
  final String? photoPath;
  final String? type;
  double? amount;
  final bool isAvailable;
  final bool oneTime;

  DriveTariff.fromJson(Map<String, dynamic> json)
      : id = json["id"] ?? json["id_tariff"],
        title = json["name"],
        type = json["type"],
        photoPath = json["photo_path"],
        isAvailable = json["isAvailable"] ?? false,
        amount = json["amount"],
        oneTime = json["one_time"];
}
