import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/driver_management/driver_management_vm.dart';
import 'package:nanny_driver/franchise/views/driver_management/drivers_list.dart';
import 'package:nanny_driver/franchise/views/driver_management/tariffs.dart';

class DriverManagementView extends StatefulWidget {
  const DriverManagementView({super.key});

  @override
  State<DriverManagementView> createState() => _DriverManagementViewState();
}

class _DriverManagementViewState extends State<DriverManagementView> {
  late DriverManagementVM vm;

  @override
  void initState() {
    super.initState();
    vm = DriverManagementVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: const NannyAppBar(
          title: "Управление водителями",
          color: NannyTheme.secondary,
          isTransparent: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              TabBar(
                indicatorColor: NannyTheme.primary,
                labelColor: NannyTheme.primary,
                unselectedLabelColor: const Color(0xFF6D6D6D),
                splashBorderRadius: BorderRadius.circular(0),
                indicatorPadding:
                    const EdgeInsets.only(top: 20, left: 16, right: 16),
                labelStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(
                    text: "Список водителей",
                  ),
                  Tab(
                    text: "Тарифы",
                  ),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    DriversListView(),
                    TarifsView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
