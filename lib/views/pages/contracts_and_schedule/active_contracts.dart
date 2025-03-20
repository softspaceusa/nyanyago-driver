import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/enums.dart';
import 'package:nanny_driver/view_models/pages/contracts_and_schedule/active_contracts_vm.dart';
import 'package:nanny_driver/views/schedule_checker.dart';

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
        var data = vm.contracts;
        if (data.isEmpty) {
          return const Center(
            child: Text("Активных контрактов нет"),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: vm.contracts.length,
          itemBuilder: (context, index) {
            var item = vm.contracts[index];
            return ScheduleWidget(
                schedule: item,
                onCancelSchedule: () => vm.cancelSchedule(item),
                onEditSchedule: () => vm.navigateToView(
                      ScheduleCheckerView(
                          schedule: item,
                          scheduleCheckerScreenType:
                              ScheduleCheckerScreenType.edit),
                    ),
                allParams: vm.params);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 20);
          },
        );
      },
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
}
