import 'package:flutter/material.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/create_user_request.dart';
import 'package:nanny_core/nanny_core.dart';

class PartnerCreateVM extends ViewModelBase {


  PartnerCreateVM({
    required super.context,
    required super.update,
  });

  GlobalKey<FormState> phoneState = GlobalKey();
  GlobalKey<FormState> passwordState = GlobalKey();
  GlobalKey<FormState> refState = GlobalKey();

  String get phone => "7${phoneMask.getUnmaskedText()}";
  MaskTextInputFormatter phoneMask = TextMasks.phoneMask();

  String password = "";
  String name = "";
  String surname = "";
  String refCode = "";

  void createUser() async {
    if(!phoneState.currentState!.validate() || 
       !passwordState.currentState!.validate() ||
       !refState.currentState!.validate()) return;

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context,
      NannyAdminApi.createUser(
        CreateUserRequest(
          phone: phone,
          password: password,
          name: name,
          surname: surname,
          role: UserType.partner.id,
          referalCode: refCode
        )
      )
    );

    if(!success) return;
    if(!context.mounted) return;

    LoadScreen.showLoad(context, false);

    await NannyDialogs.showMessageBox(context, "Успех", "Пользователь создан");

    if(!context.mounted) return;
    Navigator.pop(context);
  }
}