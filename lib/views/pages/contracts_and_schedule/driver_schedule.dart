import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/pages/contracts_and_schedule/driver_schedule_vm.dart';

class DriverScheduleView extends StatefulWidget {
  const DriverScheduleView({super.key});

  @override
  State<DriverScheduleView> createState() => _DriverScheduleViewState();
}

class _DriverScheduleViewState extends State<DriverScheduleView> {
  late DriverScheduleVM vm;

  @override
  void initState() {
    super.initState();
    vm = DriverScheduleVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureLoader(
      future: vm.loadRequest, 
      completeView: (context, data) {
        return const Center(
          child: Text("На сегодня маршрутов нет..."),
        );
      }, 
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
}