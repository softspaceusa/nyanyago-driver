import 'package:nanny_core/nanny_core.dart';

class Utils {
  /// Форматирование валюты
  static String formatCurrency(double value) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formatted = formatter.format(value).replaceFirst('.', ',');
    return "$formatted ₽";
  }
}
