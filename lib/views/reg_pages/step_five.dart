import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_pages/step_five_vm.dart';
import 'package:nanny_driver/views/reg_pages/reg_page_template.dart';

class RegStepFiveView extends StatefulWidget {
  const RegStepFiveView({super.key});

  @override
  State<RegStepFiveView> createState() => _RegStepFiveViewState();
}

class _RegStepFiveViewState extends State<RegStepFiveView> {
  late RegStepFiveVM vm;

  @override
  void initState() {
    super.initState();
    vm = RegStepFiveVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return RegPageBaseView(
      height: .8,
      children: [

        Text("Вы встретили ребенка, и он отказывается идти с вами за руку.", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Form(
          key: vm.answer1State,
          child: NannyTextForm(
            hintText: "Ваши действия?",
            maxLines: 5,
            maxLength: 500,
            onChanged: (text) => vm.answer1 = text,
            validator: (text) {
              if(text!.isEmpty) return "Введите ответ!";
              
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Text("Ребенок отказывается пристегивать ремень безопасности в автомобиле.", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Form(
          key: vm.answer2State,
          child: NannyTextForm(
            hintText: "Ваши действия?",
            maxLines: 5,
            maxLength: 500,
            onChanged: (text) => vm.answer2 = text,
            validator: (text) {
              if(text!.isEmpty) return "Введите ответ!";
              
              return null;
            },
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: vm.nextStep, 
          child: const Text("Далее"),
        ),

      ],
    );
  }
}