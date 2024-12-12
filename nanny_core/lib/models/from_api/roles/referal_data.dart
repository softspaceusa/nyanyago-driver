class Referral {
  Referral({
    required this.allIncoming,
    required this.getPercent,
  });

  final int allIncoming;
  final double getPercent;

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      allIncoming: json["all_incoming"] ?? 0,
      getPercent: json["get_percent"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "all_incoming": allIncoming,
        "get_percent": getPercent,
      };
}
