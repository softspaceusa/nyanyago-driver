import 'package:flutter/material.dart';
import 'package:nanny_components/widgets/nanny_text_forms.dart';
import 'package:nanny_driver/view_models/reg_pages/step_seven_vm.dart';
import 'package:nanny_driver/views/reg_pages.dart/reg_page_template.dart';

class RegStepSevenView extends StatefulWidget {
  const RegStepSevenView({super.key});

  @override
  State<RegStepSevenView> createState() => _RegStepSevenViewState();
}

class _RegStepSevenViewState extends State<RegStepSevenView> {
  late RegStepSevenVM vm;

  @override
  void initState() {
    super.initState();
    vm = RegStepSevenVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return RegPageBaseView(
      height: .8,
      children: [

        Text("Во время поездки случилась предаварийная ситуация, ребенок испугался.", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Form(
          key: vm.answer5State,
          child: NannyTextForm(
            hintText: "Ваши действия?",
            maxLines: 5,
            maxLength: 500,
            onChanged: (text) => vm.answer5 = text,
            validator: (text) {
              if(text!.isEmpty) return "Введите ответ!";
              
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Ребенок испачкал вам салон.", style: Theme.of(context).textTheme.labelLarge)
        ),
        const SizedBox(height: 10),
        Form(
          key: vm.answer6State,
          child: NannyTextForm(
            hintText: "Как вы отреагируете?",
            maxLines: 5,
            maxLength: 500,
            onChanged: (text) => vm.answer6 = text,
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
        
      ]
    );
  }
}