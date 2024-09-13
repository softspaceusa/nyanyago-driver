import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/view_models/app_settings_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/settings_tile.dart';

class AppSettingsView extends StatefulWidget {
  const AppSettingsView({super.key});

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView> {
  late AppSettingsVM vm;

  @override
  void initState() {
    super.initState();
    vm = AppSettingsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Настройки",
        ),
        body: FutureLoader(
          future: vm.init,
          completeView: (context, data) => ListView(
            children: [
              SettingsTile(
                title: "Вход по Touch ID", 
                description: vm.canUseBio ? (
                  vm.bioAuthEnabled ? null
                  : "Авторизация по биометрии отключена администрацией"
                ) 
                : "Ваше устройство не поддерживает биометрию",
                trailing: Switch(
                  activeColor: NannyTheme.primary,
                  value: vm.useTouchId, 
                  onChanged: vm.bioAuthEnabled ? vm.signInWithTouchId : null
                ), 
              ),
            ],
          ),
          errorView: (context, error) => ErrorView(errorText: error.toString()),
        ),
      ),
    );
  }
}