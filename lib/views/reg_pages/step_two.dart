import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/reg_pages/step_two_vm.dart';
import 'package:nanny_driver/views/reg_pages/reg_page_template.dart';

class RegStepTwoView extends StatefulWidget {
  const RegStepTwoView({super.key});

  @override
  State<RegStepTwoView> createState() => _RegStepTwoViewState();
}

class _RegStepTwoViewState extends State<RegStepTwoView> {
  late StepTwoVM vm;
  final countryNode = FocusNode();
  final surnameNode = FocusNode();
  final nameNode = FocusNode();
  final dateNode = FocusNode();
  final licenseNode = FocusNode();

  @override
  void initState() {
    super.initState();
    vm = StepTwoVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: RegPageBaseView(children: [
        Form(
            key: vm.countryState,
            child: NannyTextForm(
                controller: vm.countryTextController,
                node: countryNode,
                readOnly: true,
                onTap: vm.searchCountry,
                labelText: "Страна получения*",
                hintText: "Выберите страну",
                validator: (text) {
                  if (vm.country.id < 0) return "Выберите страну!";

                  return null;
                })),
        const SizedBox(height: 20),
        Form(
            key: vm.surnameState,
            child: NannyTextForm(
                labelText: "Фамилия*",
                node: surnameNode,
                hintText: "Введите фамилию",
                onChanged: (text) => vm.surname = text,
                validator: (text) {
                  if (text == null || text.isEmpty) return "Введите фамилию!";

                  return null;
                })),
        const SizedBox(height: 20),
        Form(
            key: vm.nameState,
            child: NannyTextForm(
                labelText: "Имя*",
                node: nameNode,
                hintText: "Введите имя",
                onChanged: (text) => vm.name = text,
                validator: (text) {
                  if (text == null || text.isEmpty) return "Введите имя!";

                  return null;
                })),
        const SizedBox(height: 20),
        Form(
            key: vm.driveLicenseState,
            child: NannyTextForm(
                node: licenseNode,
                labelText: "ВУ (водительское удостоверение)*",
                hintText: "00 00 000000",
                keyType: TextInputType.number,
                formatters: [vm.driveLicenseMask],
                validator: (text) {
                  if (vm.driveLicenseMask.getUnmaskedText().length < 10) {
                    return "Введите номер ВУ!";
                  }
                  return null;
                })),
        const SizedBox(height: 20),
        Form(
            key: vm.receiveDateState,
            child: NannyTextForm(
                node: dateNode,
                controller: vm.receiveDateController,
                labelText: "Дата выдачи*",
                hintText: "00.00.0000",
                keyType: TextInputType.number,
                formatters: [vm.receiveDateMask],
                validator: (text) {
                  if (vm.receiveDateMask.text.replaceAll('.', '').length < 8) {
                    return "Введите дату выдачи!";
                  }
                  if (!vm.validateDate()) return "Введите корректную дату!";
                  return null;
                })),
        const Spacer(),
        ElevatedButton(onPressed: vm.nextStep, child: const Text("Далее"))
      ]),
    );
  }
}
