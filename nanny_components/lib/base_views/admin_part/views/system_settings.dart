import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/views/settings/formula/formula.dart';
import 'package:nanny_components/base_views/admin_part/views/settings/other_params.dart';
import 'package:nanny_components/base_views/admin_part/views/settings/payments.dart';
import 'package:nanny_components/base_views/admin_part/views/settings/security.dart';
import 'package:nanny_components/base_views/admin_part/views/settings/updates.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/settings_tile.dart';

class SystemSettingsView extends StatefulWidget {
  const SystemSettingsView({super.key});

  @override
  State<SystemSettingsView> createState() => _SystemSettingsViewState();
}

class _SystemSettingsViewState extends State<SystemSettingsView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          title: "Настройка системы",
        ),
        body: ListView(
          children: const [
            SettingsTile(
              title: "Безопасность", 
              trailing: Icon(Icons.navigate_next),
              path: SecuritySettingsView(),
            ),
            SettingsTile(
              title: "Обновления", 
              trailing: Icon(Icons.navigate_next),
              path: UpdatesSettingsView(),
            ),
            SettingsTile(
              title: "Оплата", 
              trailing: Icon(Icons.navigate_next),
              path: PaymentsSettingsView(),
            ),
            SettingsTile(
              title: "Коэффициенты формулы", 
              trailing: Icon(Icons.navigate_next),
              path: FormulaSettingView(),
            ),
            SettingsTile(
              title: "Дополнительные услуги", 
              trailing: Icon(Icons.navigate_next),
              path: OtherParamsSettings(),
            ),
          ],
        ),
      ),
    );
  }
}