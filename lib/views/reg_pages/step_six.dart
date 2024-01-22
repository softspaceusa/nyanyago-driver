import 'package:flutter/material.dart';
import 'package:nanny_components/widgets/nanny_text_forms.dart';
import 'package:nanny_driver/view_models/reg_pages/step_six_vm.dart';
import 'package:nanny_driver/views/reg_pages/reg_page_template.dart';

class RegStepSixView extends StatefulWidget {
  const RegStepSixView({super.key});

  @override
  State<RegStepSixView> createState() => _RegStepSixViewState();
}

class _RegStepSixViewState extends State<RegStepSixView> {
  late RegStepSixVM vm;

  @override
  void initState() {
    super.initState();
    vm = RegStepSixVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return RegPageBaseView(
      height: .8,
      children: [

        Text("Ребенок мешает вам во время движения (громко разговаривает и отвлекает вас от управления автомобилем). ", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Form(
          key: vm.answer3State,
          child: NannyTextForm(
            hintText: "Ваши действия?",
            maxLines: 5,
            maxLength: 500,
            onChanged: (text) => vm.answer3 = text,
            validator: (text) {
              if(text!.isEmpty) return "Введите ответ!";
              
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("При поездке, ребенка укачало.", style: Theme.of(context).textTheme.labelLarge)
        ),
        const SizedBox(height: 10),
        Form(
          key: vm.answer4State,
          child: NannyTextForm(
            hintText: "Ваши действия?",
            maxLines: 5,
            maxLength: 500,
            onChanged: (text) => vm.answer4 = text,
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