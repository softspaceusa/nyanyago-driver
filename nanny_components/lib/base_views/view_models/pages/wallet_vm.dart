import 'package:flutter/material.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class WalletVM extends ViewModelBase {
  WalletVM({
    required super.context, 
    required super.update,
  });

  Future<ApiResponse<UserCards>> _cardRequest = NannyUsersApi.getUserCards();
  Future<ApiResponse<UserCards>> get cardRequest => _cardRequest;

  int selectedId = 0;

  void refresh() => update(() {
    _cardRequest = NannyUsersApi.getUserCards();
  });

  void selectCard(int id) => update(() => selectedId = id);

  void navigateToAddCard() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCardView()));
    refresh();
  }

  void chooseCard() => Navigator.pop(context, selectedId);
  void deleteCard() async {
    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context, 
      NannyUsersApi.deleteMyCard(id: selectedId)
    );

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);
    selectedId = 0;
    refresh();
  }
}