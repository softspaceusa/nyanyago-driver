import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_pages/step_one_vm.dart';
import 'package:nanny_driver/views/reg_pages/reg_page_template.dart';

class RegStepOneView extends StatefulWidget {
  const RegStepOneView({super.key});

  @override
  State<RegStepOneView> createState() => _RegStepOneViewState();
}

class _RegStepOneViewState extends State<RegStepOneView> {
  late RegStepOneVM vm;

  @override
  void initState() {
    super.initState();
    vm = RegStepOneVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return RegPageBaseView(
      isFirstPage: true,
      children: [
        Form(
          key: vm.passState,
          child: NannyPasswordForm(
            onChanged: (text) => vm.password = text,
            labelText: "Пароль*",
            hintText: "Придумайте пароль",
            validator: (text) {
              if(text!.length < 8) return "Пароль должен быть не меньше 8 символов!";

              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: vm.cityState,
          child: NannyTextForm(
            readOnly: true,
            labelText: "Город*",
            hintText: "Выберите город",
            controller: vm.cityTextController,
            validator: (text) {
              if(vm.city.id < 0) return "Выберите город!";
              
              return null;
            },
            onTap: vm.searchForCity,
          ),
        ),
        const SizedBox(height: 20),
        NannyTextForm(
          labelText: "Реферальный код",
          hintText: "Введите Реферальный код",
          onChanged: (text) => vm.refCode = text,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: vm.nextStep, 
          child: const Text("Далее"),
        ),
      ]
    );
  }
}