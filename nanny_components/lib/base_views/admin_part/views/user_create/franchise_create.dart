import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/user_create/franchise_create_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/static_data.dart';

class FranchiseCreateView extends StatefulWidget {
  const FranchiseCreateView({super.key});

  @override
  State<FranchiseCreateView> createState() => _FranchiseCreateViewState();
}

class _FranchiseCreateViewState extends State<FranchiseCreateView> {
  late FranchiseCreateVM vm;

  @override
  void initState() {
    super.initState();
    vm = FranchiseCreateVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Франшиза",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Выберите роль:", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                ListView(
                  shrinkWrap: true,
                  children: vm.items.map(
                    (e) => CheckboxListTile(
                      value: e.checked, 
                      title: Text(e.type.name, style: Theme.of(context).textTheme.bodyMedium),
                      activeColor: NannyTheme.primary,
                      onChanged: (value) => vm.changeSelection(e)
                    ),
                  ).toList(),
                ),
                const SizedBox(height: 20),
                Text("Сгенерируйте данные:", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 20),
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
                citiesList(vm.selectedCities),
                const SizedBox(height: 10),
                const Text("Сгенерированные данные отправятся на указанный номер телефона*"),
                const SizedBox(height: 30),
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

  Widget citiesList(List<StaticData> cities) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Город(а)*", style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(color: NannyTheme.onSecondary),
            ListView(
              shrinkWrap: true,
              children: cities.map(
                (e) => Card(
                  child: ListTile(
                    title: Text(e.title),
                    trailing: IconButton(
                      onPressed: () => vm.removeCity(e),
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ),
                ) as Widget
              ).toList()..add(
                IconButton(
                  onPressed: vm.selectCity, 
                  icon: const Icon(Icons.add)
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
