import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/settings_tile.dart';
import 'package:nanny_driver/franchise/view_models/settings/notifications_vm.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late NotificationsVM vm;

  @override
  void initState() {
    super.initState();
    vm = NotificationsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          isTransparent: false,
          title: "Настройки уведомлений",
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("В такси", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                children: vm.data.map(
                  (e) => SettingsTile(
                    title: e.name,
                    trailing: Switch(
                      value: e.enabled, 
                      onChanged: (value) => vm.changeValue(e),
                    ),
                  ),
                ).toList()
              ),
            ],
          ),
        ),
      ),
    );
  }
}