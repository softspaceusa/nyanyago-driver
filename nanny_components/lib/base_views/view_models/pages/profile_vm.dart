import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/views/app_settings.dart';
import 'package:nanny_components/dialogs/loading.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/update_me_request.dart';
import 'package:nanny_core/nanny_core.dart';

class ProfileVM extends ViewModelBase {
  ProfileVM({
    required super.context,
    required super.update,
    required this.logoutView,
  });

  final Widget logoutView;
  String? firstName;
  String? lastName;
  String? photoPath;
  int? inn;

  String? errorText;
  GlobalKey<FormState> passwordState = GlobalKey();

  String? validatePassword(String? password) {
    if (password == null) return null;
    if (password.length < 8) {
      return 'Пароль не меньше 8 символов';
    }
    if (!containsUpperCase(password)) {
      return 'Пароль солжен содержать заглавные буквы';
    }
    if (!containsSpecialCharacter(password)) {
      return 'Пароль должен содержать символы';
    }
    if (!containsDigit(password)) {
      return 'Пароль должен содержать цифры';
    }

    return null;
  }

  bool containsDigit(String input) {
    final RegExp digitRegExp = RegExp(
      r'^(?=.*\d).+$',
    );
    return digitRegExp.hasMatch(input);
  }

  bool containsSpecialCharacter(String input) {
    final RegExp specialCharRegExp = RegExp(
      r'^(?=.*[\W_]).+$',
    );
    return specialCharRegExp.hasMatch(input);
  }

  bool containsUpperCase(String input) {
    final RegExp upperCaseRegExp = RegExp(
      r'^(?=.*[A-Z]).+$',
    );
    return upperCaseRegExp.hasMatch(input);
  }

  void changePassword() async {
    String? password;

    bool? checked = await _checkOldPassword();
    if (checked == null) return;
    if (!checked) {
      if (!context.mounted) return;

      NannyDialogs.showMessageBox(context, "Ошибка", "Пароли не совпали!");

      return;
    }

    if (!context.mounted) return;

    password = await _promtChangePass();

    update(() {
      errorText = validatePassword(password);
    });

    if (!passwordState.currentState!.validate()) return;

    if (password == null) return;
    if (!context.mounted) return;

    if (password.isEmpty || password.length < 8) {
      NannyDialogs.showMessageBox(
          context, "Ошибка", "Пароль должен быть не меньше 8 символов!");
      return;
    }

    bool success = await DioRequest.handleRequest(
      context,
      NannyUsersApi.updateMe(UpdateMeRequest(
        password: password,
      )),
    );

    if (!success) return;

    var data = (await NannyStorage.getLoginData())!;
    NannyStorage.updateLoginData(
      LoginStorageData(
        login: data.login,
        password: password,
        // haveSetPincode: data.haveSetPincode,
      ),
    );

    if (!context.mounted) return;

    LoadScreen.showLoad(context, false);
    NannyDialogs.showMessageBox(context, "Успех", "Пароль успешно измен");
  }

  Future<bool?> _checkOldPassword() async {
    String password = "";

    bool keepGoing = await NannyDialogs.showModalDialog(
      context: context,
      title: "Изменение пароля",
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              const Text('Введите старый пароль аккаунта'),
              Padding(
                padding: const EdgeInsets.only(top: 33, bottom: 29),
                child: NannyPasswordForm(
                    isExpanded: true,
                    labelText: 'Старый пароль',
                    onChanged: (text) => password = text),
              ),
            ],
          ),
        ),
      ),
    );
    if (!keepGoing) return null;

    var loginData = await NannyStorage.getLoginData();

    Logger().w("Login data - ${loginData!.password}");
    Logger().w("Password - ${Md5Converter.convert(password)}");

    if (Md5Converter.convert(password) != loginData.password) return false;
    return true;
  }

  Future<String?> _promtChangePass() async {
    String? password;
    bool keepGoing = await NannyDialogs.showModalDialog(
      context: context,
      title: "Изменение пароля",
      child: Form(
        key: passwordState,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 60,
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                const Text('Введите новый пароль аккаунта'),
                Padding(
                  padding: const EdgeInsets.only(top: 33, bottom: 29),
                  child: NannyPasswordForm(
                    isExpanded: true,
                    labelText: 'Новый пароль',
                    //errorText: errorText,
                    validator: (text) {
                      if (password!.length < 8) {
                        return "Пароль не меньше 8 символов!";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      password = text;
                      errorText = null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!keepGoing) return null;

    return password;
  }

  void changeProfilePhoto() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    if (!context.mounted) return;

    LoadScreen.showLoad(context, true);

    var upload = NannyFilesApi.uploadFiles([file]);
    bool uploaded = await DioRequest.handleRequest(
      context,
      upload,
    );

    if (!uploaded) return;
    if (!context.mounted) return;

    LoadScreen.showLoad(context, true);

    bool updated = await DioRequest.handleRequest(
      // ignore: use_build_context_synchronously
      context,
      NannyUsersApi.updateMe(UpdateMeRequest(
        photoPath: (await upload).response!.paths.first,
      )),
    );

    if (!updated) return;
    if (!context.mounted) return;

    LoadScreen.showLoad(context, false);
    NannyDialogs.showMessageBox(context, "Успех", "Фото профиля обновлено!");
    await NannyUser.getMe();

    update(() {});
  }

  void changePincode() async {
    String code = "";
    bool proceed = await NannyDialogs.showModalDialog(
      context: context,
      title: "Введите старый пин-код",
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          padding: const EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.only(top: 33, bottom: 29),
            child: NannyPasswordForm(
              isExpanded: true,
              labelText: 'Старый пин-код',
              onChanged: (text) => code = text,
              keyType: TextInputType.number,
              formatters: [
                MaskTextInputFormatter(mask: "####", filter: {
                  '#': RegExp(r"[0-9]"),
                })
              ],
            ),
          ),
        ),
      ),
    );

    if (!proceed) return;

    if (!context.mounted) return;

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context,
      NannyAuthApi.checkPinCode(code),
    );

    if (!success) return;

    if (!context.mounted) return;

    LoadScreen.showLoad(context, false);

    code = "";
    bool confirm = await NannyDialogs.showModalDialog(
      context: context,
      title: "Введите новый пин-код",
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          padding: const EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.only(top: 33, bottom: 29),
            child: NannyPasswordForm(
              isExpanded: true,
              labelText: 'Новый пин-код',
              onChanged: (text) => code = text,
              keyType: TextInputType.number,
              formatters: [
                MaskTextInputFormatter(mask: "####", filter: {
                  '#': RegExp(r"[0-9]"),
                })
              ],
            ),
          ),
        ),
      ),
    );

    if (!confirm) return;
    if (code.length < 4) {
      if (context.mounted) {
        NannyDialogs.showMessageBox(
            context, "Ошибка", "Пин-код должен состоять из 4-х цифр");
      }
      return;
    }

    if (!context.mounted) return;

    LoadScreen.showLoad(context, true);

    bool changed = await DioRequest.handleRequest(
      context,
      NannyAuthApi.setPinCode(code),
    );

    if (!changed) return;
    if (!context.mounted) return;

    LoadScreen.showLoad(context, false);
    NannyDialogs.showMessageBox(context, "Успех", "Пин-код изменён");
  }

  void saveChanges() async {
    if (firstName == null || lastName == null) return;
    if (firstName!.isEmpty || lastName!.isEmpty) return;

    LoadScreen.showLoad(context, true);

    bool success = await DioRequest.handleRequest(
      context,
      NannyUsersApi.updateMe(UpdateMeRequest(
        firstName: firstName,
        lastName: lastName,
      )),
    );

    if (!success) return;

    await NannyUser.getMe();

    if (!context.mounted) return;

    LoadScreen.showLoad(context, false);

    NannyDialogs.showMessageBox(context, "Успех", "Данные обновлены!");

    update(() {});
  }

  void logout() async {
    var success = await DioRequest.handleRequest(context, NannyUser.logout());

    if (!success) return;
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => logoutView), (route) => false);
  }

  void navigateToAppSettings() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AppSettingsView()),
      );
}
