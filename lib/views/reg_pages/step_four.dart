import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_pages/step_four_vm.dart';
import 'package:nanny_driver/views/reg_pages/reg_page_template.dart';

class RegStepFourView extends StatefulWidget {
  const RegStepFourView({super.key});

  @override
  State<RegStepFourView> createState() => _RegStepFourViewState();
}

class _RegStepFourViewState extends State<RegStepFourView> {
  late RegStepFourVM vm;

  @override
  void initState() {
    super.initState();
    vm = RegStepFourVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return RegPageBaseView(height: .9, children: [
      Form(
          key: vm.aboutMeState,
          child: NannyTextForm(
              labelText: "О себе*",
              hintText: "Напишите несколько слов о себе",
              maxLines: 5,
              onChanged: (text) => vm.aboutMe = text,
              maxLength: 500,
              validator: (text) {
                if (text!.isEmpty) return "Напишите о себе!";

                return null;
              })),
      const SizedBox(height: 10),
      Form(
          key: vm.ageState,
          child: NannyTextForm(
              labelText: "Возраст*",
              hintText: "Введите возраст",
              controller: vm.ageController,
              keyType: TextInputType.number,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (text) {
                if (text.length > 2) {
                  vm.age = text.substring(0, 2);
                  vm.ageController.text = vm.age;
                  return;
                }
                vm.age = text;
              },
              validator: (text) {
                if (text!.isEmpty) return "Введите возраст!";
                var parsed = int.tryParse(text);
                if (parsed == null || parsed < 18) return "Некорректный возраст!";
                return null;
              })),
      const SizedBox(height: 20),
      fileButton(
          label: "Фото*",
          description: "Загрузите фотографию",
          icon: Icons.image_outlined,
          onTap: vm.getPicture,
          success: vm.photoLoaded
              ? FittedBox(
                  child: NetImage(url: vm.photoPath, fitToShortest: false))
              : null),
      const SizedBox(height: 20),
      Expanded(
          flex: 2,
          child: fileButton(
              label: "Видео",
              description:
                  "Запишите видео-приветствие на камеру, видео может длиться 10-15 секунд",
              icon: Icons.camera_alt_outlined,
              onTap: vm.getVideo,
              success: vm.videoLoaded
                  ? const Icon(Icons.done, size: 50, color: NannyTheme.green)
                  : null)),
      const Spacer(),
      ElevatedButton(onPressed: vm.nextStep, child: const Text("Далее"))
    ]);
  }

  Widget fileButton({
    required String label,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    Widget? success,
  }) {
    return ElevatedButton(
        onPressed: onTap,
        style: NannyButtonStyles.whiteButton,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label),
                            Text(description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal)),
                          ])),
                  success ?? Icon(icon, size: 50)
                ])));
  }
}
