import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/today_schedule_view.dart';
import 'package:nanny_driver/view_models/pages/contracts_and_schedule/active_contracts_vm.dart';

class ActiveContractsView extends StatefulWidget {
  const ActiveContractsView({super.key});

  @override
  State<ActiveContractsView> createState() => _ActiveContractsViewState();
}

class _ActiveContractsViewState extends State<ActiveContractsView> {
  late ActiveContractsVM vm;

  @override
  void initState() {
    super.initState();
    vm = ActiveContractsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureLoader(
      future: vm.loadRequest, 
      completeView: (context, data) {
        if(!data) return const ErrorView(errorText: "Не удалось загрузить данные!");
    
        if(vm.schedules.isEmpty) {
          return const Center(
            child: Text("У вас ещё нет активных контрактов..."),
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