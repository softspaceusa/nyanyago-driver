import 'package:flutter/material.dart';
import 'package:nanny_components/widgets/nanny_text_forms.dart';
import 'package:nanny_driver/view_models/reg_pages/step_eight_vm.dart';
import 'package:nanny_driver/views/reg_pages/reg_page_template.dart';

class RegStepEightView extends StatefulWidget {
  const RegStepEightView({super.key});

  @override
  State<RegStepEightView> createState() => _RegStepEightViewState();
}

class _RegStepEightViewState extends State<RegStepEightView> {
  late RegStepEightVM vm;

  @override
  void initState() {
    super.initState();
    vm = RegStepEightVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return RegPageBaseView(
      children: [

        Text("Вы попали в ДТП, ребенок получил травму.", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Form(
          key: vm.answer7State,
          child: NannyTextForm(
            hintText: "Ваши действия пошагово?",
            maxLines: 10,
            maxLength: 500,
            onChanged: (text) => vm.answer7 = text,
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