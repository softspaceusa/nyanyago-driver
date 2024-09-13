class DriveTariff {
  DriveTariff({
    required this.id,
    this.title,
    this.photoPath,
    this.amount,
    this.isAvailable = false,
  });

  final int id;
  final String? title;
  final String? photoPath;
  double? amount;
  final bool isAvailable;

  DriveTariff.fromJson(Map<String, dynamic> json)
    : id = json["id"] ?? json["id_tariff"],
      title = json["title"],
      photoPath = json["photo_path"],
      isAvailable = json["isAvailable"] ?? false,
      amount = json["amount"];
}

// [
//   {
//     "id": 1,
//     "title": "Эконом"
//   },
//   {
//     "id": 2,
//     "title": "Комфорт"
//   },
//   {
//     "id": 3,
//     "title": "Комфорт +"
//   },
//   {
//     "id": 4,
//     "title": "Бизнес"
//   },
//   {
//     "id": 5,
//     "title": "Минивэн"
//   }
// ]