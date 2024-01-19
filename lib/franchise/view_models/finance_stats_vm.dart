import 'package:nanny_components/nanny_components.dart';

class FinanceStatsVM extends ViewModelBase {
  FinanceStatsVM({
    required super.context, 
    required super.update,
  });

  bool expensesSelected = true;
  String moneySpended = "0 Р";
  DateTime selectedMonth = DateTime.now();

  void changeSelection(bool expenses) => update(() => expensesSelected = expenses);
  void monthSelected(int month) => update(
    () => selectedMonth = DateTime(selectedMonth.year, month, 1)
  );
}