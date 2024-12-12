import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/franchise/finance_stats_model.dart';
import 'package:nanny_core/nanny_core.dart';

class FinanceStatsVM extends ViewModelBase {
  FinanceStatsVM({
    required super.context,
    required super.update,
  });

  bool expensesSelected = true;
  String moneySpended = "0 Р";
  String moneyEarned = "0 Р";

  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  // Хранение текущей статистики
  Future<ApiResponse<FinanceStatsModel?>>? _financeStatsRequest;

  Future<ApiResponse<FinanceStatsModel?>> get financeStats =>
      _financeStatsRequest ??= _loadFinanceStats();

  /// Метод для загрузки статистики с сервера
  Future<ApiResponse<FinanceStatsModel?>> _loadFinanceStats() async {
    final now = DateTime.now();
    final int period = (now.year - selectedMonth.year) * 12 +
        (now.month - selectedMonth.month);
    final response = await NannyUsersApi.getMoneyStats(period: -period);

    if (response.success && response.response != null) {
      updateFinanceStats(response.response!); // Обновляем данные в VM
    }

    return response;
  }

  /// Метод для обновления данных при изменении месяца
  void monthSelected(int month) => update(() {
        selectedMonth = DateTime(selectedMonth.year, month, 1);
        _financeStatsRequest = null; // Сбрасываем кэш
        _financeStatsRequest = _loadFinanceStats(); // Перезапускаем запрос
      });

  /// Метод для переключения между доходами и расходами
  void changeSelection(bool expenses) =>
      update(() => expensesSelected = expenses);

  /// Обновление состояния и форматирование значений
  void updateFinanceStats(FinanceStatsModel stats) {
    update(() {
      moneySpended = formatCurrency(stats.minus.total);
      moneyEarned = formatCurrency(stats.plus.total);
    });
  }

  /// Форматирование валюты
  String formatCurrency(double value) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formatted = formatter.format(value).replaceFirst('.', ',');
    return "$formatted Р";
  }
}

/// Класс для описания данных, возвращаемых API
