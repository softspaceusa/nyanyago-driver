import 'package:flutter/material.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class BalanceVM extends ViewModelBase {
  BalanceVM({
    required super.context,
    required super.update,
  });

  bool isCashbackButtonSelected = false;

  Future<ApiResponse<UserMoney>> get getMoney => _moneyRequest;
  Future<ApiResponse<UserMoney>> _moneyRequest =
      NannyUsersApi.getMoney(period: 'current_year');

  Future<ApiResponse<UserCards>> _cardRequest = NannyUsersApi.getUserCards();
  Future<ApiResponse<UserCards>> get cardRequest => _cardRequest;
  int? selectedId;

  void selectCard(int id) =>
      update(() => selectedId = (selectedId == id ? null : id));

  Future deleteCard(int id) async {
    bool confirm = await NannyDialogs.confirmAction(context, "Удалить карту?");
    if (!confirm) return;
    if (!context.mounted) return;

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
        context, NannyUsersApi.deleteMyCard(id: id));

    if (!context.mounted) return;
    if (!success) {
      NannyDialogs.showMessageBox(
          context, "Ошибка", "Не удалось удалить карту!");
      return;
    }

    LoadScreen.showLoad(context, false);
    NannyDialogs.showMessageBox(context, "Успех", "Карта удалена");
    _cardRequest = NannyUsersApi.getUserCards();
    update(() {});
  }

  void changeSwitchType({required bool isCashbackButtonSelected}) =>
      update(() => this.isCashbackButtonSelected = isCashbackButtonSelected);

  void updateState() => update(() {
        _moneyRequest = NannyUsersApi.getMoney(period: 'current_year');
      });

  void toPay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WalletView(
            title: "Вывод средств",
            subtitle: "Выберите карту для вывода средств",
            hasReplenishButtons: true),
      ),
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
                )));
  }

  void navigateToAddCard() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddCardView()));
    refresh();
  }

  void refresh() => update(() {
        _cardRequest = NannyUsersApi.getUserCards();
      });
}
