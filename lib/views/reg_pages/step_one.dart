import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_pages/step_one_vm.dart';
import 'package:nanny_driver/views/reg_pages/reg_page_template.dart';

class RegStepOneView extends StatefulWidget {
  const RegStepOneView(this.callback, {super.key});

  final Function(int) callback;

  @override
  State<RegStepOneView> createState() => _RegStepOneViewState();
}

class _RegStepOneViewState extends State<RegStepOneView> {
  late RegStepOneVM vm;

  @override
  void initState() {
    super.initState();
    vm = RegStepOneVM(
        context: context, update: setState, nextStepCall: widget.callback);
  }

  @override
  Widget build(BuildContext context) {
    return RegPageBaseView(
      isFirstPage: true,
      children: [
        Form(
          key: vm.passState,
          child: NannyPasswordForm(
            isExpanded: true,
            onChanged: (text) => vm.password = text,
            labelText: "Пароль*",
            hintText: "Придумайте пароль",
            validator: (text) {
              return validatePassword(text);
            },
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: vm.cityState,
          child: NannyTextForm(
              isExpanded: true,
              readOnly: true,
              labelText: "Город*",
              hintText: "Выберите город",
              controller: vm.cityTextController,
              validator: (text) {
                if (vm.city.id < 0) return "Выберите город!";

                return null;
              },
              onTap: vm.searchForCity),
        ),
        const SizedBox(height: 20),
        NannyTextForm(
            isExpanded: true,
            labelText: "Реферальный код",
            hintText: "Введите реферальный код",
            onChanged: (text) => vm.refCode = text),
        const SizedBox(height: 20),
        Form(
          key: vm.innState,
          child: NannyTextForm(
            isExpanded: true,
            labelText: "ИНН*",
            hintText: "Введите ИНН",
            onChanged: (text) => vm.inn = text,
            validator: (text) {
              if (vm.inn.isEmpty) return "Введите ИНН!";

              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: vm.nextStep,
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            minimumSize: const WidgetStatePropertyAll(
              Size(double.infinity, 60),
            ),
          ),
          child: const Text("Далее"),
        ),
      ],
    );
  }

  String? validatePassword(String? password) {
    if (password == null) return null;
    if (password.length < 8) {
      return 'Пароль не меньше 8 символов';
    }
    if (!containsUpperCase(password)) {
      return 'Пароль должен содержать заглавные буквы';
    }
    if (!containsSpecialCharacter(password)) {
      return 'Пароль должен содержать специальные символы';
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
}
