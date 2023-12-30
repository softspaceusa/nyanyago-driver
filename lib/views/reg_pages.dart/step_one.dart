import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';

class RegStepOneView extends StatefulWidget {
  const RegStepOneView({super.key});

  @override
  State<RegStepOneView> createState() => _RegStepOneViewState();
}

class _RegStepOneViewState extends State<RegStepOneView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        NannyTextForm(
          labelText: "Пароль*",
          hintText: "Придумайте пароль",
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
        Spacer(),
        ElevatedButton(
          onPressed: () {}, 
          child: const Text("Далее"),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}