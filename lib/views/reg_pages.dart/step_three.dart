import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_pages/step_three_vm.dart';
import 'package:nanny_driver/views/reg_pages.dart/reg_page_template.dart';

class RegStepThreeView extends StatefulWidget {
  const RegStepThreeView({super.key});

  @override
  State<RegStepThreeView> createState() => _RegStepThreeViewState();
}

class _RegStepThreeViewState extends State<RegStepThreeView> {
  late StepThreeVM vm;

  @override
  void initState() {
    super.initState();
    vm = StepThreeVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return RegPageBaseView(
      children: [
        
        Form(
          key: vm.markState,
          child: NannyTextForm(
            controller: vm.markController,
            readOnly: true,
            labelText: "Марка авто*",
            onTap: vm.searchMark,
            validator: (text) {
              if(vm.carMark.id == -1) return "Выберите марку авто!";
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: vm.modelState,
          child: NannyTextForm(
            controller: vm.modelController,
            readOnly: true,
            enabled: vm.isMarkSelected,
            labelText: "Модель авто*",
            onTap: vm.searchModel,
            validator: (text) {
              if(vm.carModel.id == -1) return "Выберите модель авто!";
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: vm.colorState,
          child: NannyTextForm(
            controller: vm.colorController,
            readOnly: true,
            labelText: "Цвет*",
            onTap: vm.searchColor,
            validator: (text) {
              if(vm.carColor.id == -1) return "Выберите цвет авто!";
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        NannyTextForm(
          controller: vm.yearController,
          readOnly: true,
          enabled: vm.isMarkSelected,
          labelText: "Год выпуска*",
        ),
        const SizedBox(height: 20),
        Form(
          key: vm.stateNumState,
          child: NannyTextForm(
            labelText: "Госномер*",
            hintText: "А 000 АА",
            formatters: [
              NannyUpperFormatter(),
              vm.stateNumMask
            ],
            validator: (text) {
              if(!vm.stateNumMask.isFill()) return "Заполните госномер!";
              return null;
            },
            // onChanged: (text) {},
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: vm.stsState,
          child: NannyTextForm(
            labelText: "СТС*",
            hintText: "00 АА 000000",
            formatters: [
              NannyUpperFormatter(),
              vm.stsMask
            ],
            validator: (text) {
              if(!vm.stsMask.isFill()) return "Заполниет СТС!";
              return null;
            },
            // onChanged: (text) {},
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