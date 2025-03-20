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
        if (!data) {
          return const Center(
              child: ErrorView(errorText: "Не удалось загрузить данные!"));
        }

        if (vm.schedules.isEmpty) {
          return const Center(
            child: Text("На сегодня маршрутов нет..."),
          );
        }

        return Stack(
          children: [
            ListView.separated(
                padding: const EdgeInsets.only(
                    top: 24, bottom: 100, left: 16, right: 16),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final road = vm.schedules[index];
                  return TodayScheduleView(
                      schedule: road,
                      onPressed: () => vm.selectRoad(road.id),
                      isSelected: vm.selectedId == road.id);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: vm.schedules.length),
            Visibility(
              visible: vm.selectedId != null,
              child: Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () => vm.startOrder(vm.selectedId!),
                  style: NannyButtonStyles.main,
                  child: const Text('Начать поездку'),
                ),
              ),
            ),
          ],
        );
      },
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
}
