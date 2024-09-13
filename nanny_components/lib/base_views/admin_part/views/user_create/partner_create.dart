import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/user_create/partner_create_vm.dart';
import 'package:nanny_components/nanny_components.dart';

class PartnerCreateView extends StatefulWidget {
  const PartnerCreateView({super.key});

  @override
  State<PartnerCreateView> createState() => _PartnerCreateViewState();
}

class _PartnerCreateViewState extends State<PartnerCreateView> {
  late PartnerCreateVM vm;

  @override
  void initState() {
    super.initState();
    vm = PartnerCreateVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Партнер",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Сгенерируйте данные", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                Form(
                  key: vm.phoneState,
                  child: NannyTextForm(
                    labelText: "Номер телефона*",
                    hintText: "+7 (777) 777-77-77",
                    formatters: [vm.phoneMask],
                    validator: (text) {
                      if(vm.phone.length < 11) {
                        return "Введите номер телефона!";
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: vm.passwordState,
                  child: NannyTextForm(
                    labelText: "Пароль*",
                    hintText: "••••••••",
                    onChanged: (text) => vm.password = text,
                    validator: (text) {
                      if(text!.length < 8) {
                        return "Пароль не меньше 8 символов!";
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: vm.refState,
                  child: NannyTextForm(
                    labelText: "Реферальная ссылка*",
                    onChanged: (text) => vm.refCode = text,
                    validator: (text) {
                      if(text!.isEmpty) {
                        return "Введите реф ссылку!";
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Сгенерированные данные отправятся на указанный номер телефона*"),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                      onPressed: vm.createUser,
                      child: const Text("Отправить данные")
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}