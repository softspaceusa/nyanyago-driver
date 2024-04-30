import 'package:flutter/material.dart';
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

  void toPay() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const WalletView(
          title: "Вывод средств", 
          subtitle: "Выберите карту для вывода средств",
          hasReplenishButtons: true,
        )
      )
    );
  }

  void toCashback() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const WalletView(
          title: "Получение кэшбека", 
          subtitle: "Выберите карту, на которую запросится кэшбек",
          hasReplenishButtons: true,
        )
      )
    );
  }
}