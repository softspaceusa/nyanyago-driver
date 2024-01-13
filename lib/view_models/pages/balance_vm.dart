import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class BalanceVM extends ViewModelBase {
  BalanceVM({
    required super.context,
    required super.update,
  });

  Future<ApiResponse<UserMoney>> get getMoney => _moneyRequest;
  Future<ApiResponse<UserMoney>> _moneyRequest = NannyUsersApi.getMoney();
  void updateState() => update( () { _moneyRequest = NannyUsersApi.getMoney(); });

  void navigateToWallet() => navigateToView(const WalletView(
    title: "Вывод средств",
    subtitle: "Выберите карту для вывода средств",
  ));
}