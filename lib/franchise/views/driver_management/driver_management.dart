import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/driver_management_vm.dart';
import 'package:nanny_driver/franchise/views/driver_management/drivers_list.dart';
import 'package:nanny_driver/franchise/views/driver_management/tarifs.dart';

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
    return const SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: NannyAppBar(
            title: "Управление водителями",
            bottom: TabBar(
              labelColor: NannyTheme.primary,
              unselectedLabelColor: NannyTheme.onSecondary,
              indicatorColor: NannyTheme.primary,
              tabs: [
                Tab(
                  text: "Список водителей",
                ),
                Tab(
                  text: "Тарифы",
                ),
              ]
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              DriversListView(),
              TarifsView(),
            ]
          ),
        ),
      ),
    );
  }
}