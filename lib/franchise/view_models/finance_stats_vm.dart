import 'package:nanny_components/nanny_components.dart';

class FinanceStatsVM extends ViewModelBase {
  FinanceStatsVM({
    required super.context, 
    required super.update,
  });

  bool expensesSelected = true;

  void changeSelection(bool expenses) => update(() => expensesSelected = expenses);
}