import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_franchise_api.dart';
import 'package:nanny_core/models/from_api/franchise/payout_model.dart';
import 'package:nanny_core/nanny_core.dart';

class MoneyHistoryVM extends ViewModelBase {
  MoneyHistoryVM({
    required super.context,
    required super.update,
  });

  List<PayoutModel> payouts = [];
  bool isLoading = false;
  String? error;

  /// Тип дат (по умолчанию день)
  DateType selectedDateType = DateType.day;

  /// Выбор типа даты
  void onSelect(Set<DateType> type) {
    update(() => selectedDateType = type.first);
    reloadPage();
  }

  /// Запрос данных выплат
  Future<ApiResponse<List<PayoutModel>>> loadPayouts() async {
    return NannyFranchiseApi.getPartnerPayouts();
  }

  /// Перезагрузка страницы
  void reloadPage() async {
    payouts = (await loadPayouts()).response ?? [];
  }
}
