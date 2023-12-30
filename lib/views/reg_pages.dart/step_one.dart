import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_pages/step_one_vm.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Form(
                key: vm.passwordState,
                child: NannyTextForm(
                  labelText: "Пароль*",
                  hintText: "Придумайте пароль",
                  validator: (text) {
                    if(text!.length < 8) return "Пароль должен быть не меньше 8 символов!";

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              NannyTextForm(
                labelText: "Город*",
                hintText: "Выберите город",
              ),
              const SizedBox(height: 20),
              NannyTextForm(
                labelText: "Реферальный код",
                hintText: "Введите Реферальный код",
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {}, 
                child: const Text("Далее"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}