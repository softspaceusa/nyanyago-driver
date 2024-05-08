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
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: NannyAppBar(
            title: "Управление водителями",
            bottom: TabBar(
              indicatorColor: NannyTheme.primary,
              labelColor: NannyTheme.primary,
              unselectedLabelColor: NannyTheme.onSecondary,
              splashBorderRadius: BorderRadius.circular(30),
              indicator: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(
                    width: 4,
                    color: NannyTheme.primary
                  )
                ),
                borderRadius: BorderRadius.circular(30)
              ),
              tabs: const [
                Tab(
                  text: "Список водителей",
                ),
                Tab(
                  text: "Тарифы",
                ),
              ]
            ),
          ),
          body: const TabBarView(
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