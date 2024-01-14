import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/settings_tile.dart';
import 'package:nanny_driver/franchise/views/settings/notifications.dart';
import 'package:nanny_driver/franchise/views/settings/security.dart';

class FranchiseSettingsView extends StatefulWidget {
  const FranchiseSettingsView({super.key});

  @override
  State<FranchiseSettingsView> createState() => _FranchiseSettingsViewState();
}

class _FranchiseSettingsViewState extends State<FranchiseSettingsView> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        appBar: NannyAppBar(
          isTransparent: false,
          title: "Управление настройками",
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              
              SettingsTile(
                title: "Настройки уведомлений", 
                path: NotificationsView(),
              ),
              SettingsTile(
                title: "Настройки безопасности",
                path: SecurityView(),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}