import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/settings_tile.dart';
import 'package:nanny_driver/franchise/view_models/settings/franchise_security_vm.dart';

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  late FranchiseSecurityVM vm;

  @override
  void initState() {
    super.initState();
    vm = FranchiseSecurityVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          isTransparent: false,
          title: "Настройки безопасности",
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
          
              Text("Разрешить доступ к панели управления:", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                children: vm.panelData.map(
                  (e) => SettingsTile(
                    title: e.name,
                    trailing: Switch(
                      value: e.enabled,
                      onChanged: (value) => vm.changeValue(e, "panel"),
                    )
                  )
                ).toList(),
              ),
              const SizedBox(height: 30),
              Text("Управление правами доступа других пользователей:", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                children: vm.panelData.map(
                  (e) => SettingsTile(
                    title: e.name,
                    trailing: Switch(
                      value: e.enabled,
                      onChanged: (value) => vm.changeValue(e, "permissions"),
                    )
                  )
                ).toList(),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}