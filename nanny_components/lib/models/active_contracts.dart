class ActiveContractsModel {
  final String type;
  final String title;
  final List<String> actions;
  final List<DateTime> schedules;
  final num price;
  final num wholePrice;
  final int childrenCount;
  final String name;
  final String avatar;

  ActiveContractsModel(
      {required this.type,
      required this.title,
      required this.actions,
      required this.price,
      required this.wholePrice,
      required this.childrenCount,
      required this.schedules,
      required this.name,
      required this.avatar});

  String get childCountStr {
    return childrenCount > 1
        ? '$childrenCount детей'
        : '$childrenCount ребенок';
  }
}
