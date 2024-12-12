import 'package:nanny_components/view_model_base.dart';
import 'package:nanny_core/nanny_core.dart';

class FinanceManagementVM extends ViewModelBase {
  FinanceManagementVM({
    required super.context,
    required super.update,
  });

  bool withdrawSelected = false;
  Set<DateType> selectedDateType = const {DateType.day};

  Future<ApiResponse<UserMoney>> get getMoney => _moneyRequest;
  Future<ApiResponse<UserMoney>> _moneyRequest = NannyUsersApi.getMoney();
  void updateState() => update(() {
        _moneyRequest = NannyUsersApi.getMoney();
      });

  void statsSwitch({required bool switchToWithdraw}) {
    withdrawSelected = switchToWithdraw;
    updateState();
  }

  void onDateTypeSelect(Set<DateType>? type) {
    selectedDateType = type!;
    updateState();
  }

  String formatCurrency(double balance) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formatted =
        formatter.format(balance).replaceAll(',', ' ').replaceAll('.', ', ');
    return "$formatted Р";
  }
}
