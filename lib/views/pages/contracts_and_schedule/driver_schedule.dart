import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/today_schedule_view.dart';
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
        if(!data) return const ErrorView(errorText: "Не удалось загрузить данные!");
    
        if(vm.schedules.isEmpty) {
          return const Center(
            child: Text("На сегодня маршрутов нет..."),
          );
        }
    
        return Column(
          children: [
            const SizedBox(height: 10),
            Text("На сегодня:", style: Theme.of(context).textTheme.displayLarge),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: vm.schedules.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TodayScheduleView(
                      schedule: e,
                      onPressed: () => vm.viewSchedule(e.id),
                    ),
                  )
                ).toList(),
              ),
            ),
          ],
        );
      }, 
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
}