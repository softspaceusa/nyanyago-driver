class FinanceStatsModel {
  final FinancePart minus;
  final FinancePart plus;

  FinanceStatsModel({required this.minus, required this.plus});

  factory FinanceStatsModel.fromJson(Map<String, dynamic> json) {
    return FinanceStatsModel(
      minus: FinancePart.fromJson(json['minus'] as Map<String, dynamic>),
      plus: FinancePart.fromJson(json['plus'] as Map<String, dynamic>),
    );
  }
}

class FinancePart {
  final double spendingOnDrivers;
  final double spendingOnBonuses;

  FinancePart({
    required this.spendingOnDrivers,
    required this.spendingOnBonuses,
  });

  double get total => spendingOnDrivers + spendingOnBonuses;

  factory FinancePart.fromJson(Map<String, dynamic> json) {
    return FinancePart(
      spendingOnDrivers:
          (json['spending_on_drivers'] as num?)?.toDouble() ?? 0.0,
      spendingOnBonuses:
          (json['spending_on_bonuses'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
