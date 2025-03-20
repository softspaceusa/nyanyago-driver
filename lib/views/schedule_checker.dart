import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/schedule_viewer.dart';
import 'package:nanny_core/enums.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_driver/view_models/schedule_checker_vm.dart';

class ScheduleCheckerView extends StatefulWidget {
  final Schedule schedule;
  final ScheduleCheckerScreenType scheduleCheckerScreenType;

  const ScheduleCheckerView({
    super.key,
    required this.schedule,
    required this.scheduleCheckerScreenType,
  });

  @override
  State<ScheduleCheckerView> createState() => _ScheduleCheckerViewState();
}

class _ScheduleCheckerViewState extends State<ScheduleCheckerView> {
  late final ScheduleCheckerVm vm;
  late String buttonText;
  late VoidCallback buttonAction;

  @override
  void initState() {
    super.initState();
    buttonText = {
      ScheduleCheckerScreenType.response: "Откликнуться на заявку",
      ScheduleCheckerScreenType.edit: "Удалить выбранный день",
      ScheduleCheckerScreenType.intentionStart: "Начать поездку",
    }[widget.scheduleCheckerScreenType]!;

    vm = ScheduleCheckerVm(
        context: context, update: setState, schedule: widget.schedule);

    final actions = <ScheduleCheckerScreenType, VoidCallback>{
      ScheduleCheckerScreenType.response: vm.wantSchedule,
      ScheduleCheckerScreenType.edit: vm.declineRoads,
      ScheduleCheckerScreenType.intentionStart: vm.declineRoads,
    };

    buttonAction = actions[widget.scheduleCheckerScreenType] ?? () {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FF),
      appBar: NannyAppBar(
        hasBackButton: false,
        title: widget.scheduleCheckerScreenType ==
                ScheduleCheckerScreenType.intentionStart
            ? 'График работы на сегодня'
            : 'График поездок',
        color: const Color(0xFFF6F5FF),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              CupertinoButton(
                onPressed: () {},
                child: Image.asset(
                    'packages/nanny_components/assets/images/driver_graph.png',
                    height: 180),
              ),
              /*Row(
                children: [
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: vm.wantSchedule,
                      child: const Text("Принять заявку")),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text("Выбрать всё",
                          style: Theme.of(context).textTheme.bodySmall),
                      activeColor: NannyTheme.primary,
                      value: vm.selectAll,
                      onChanged: vm.selectAllChanged,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),*/
              const SizedBox(height: 10),
              Expanded(
                child: NannyBottomSheet(
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 20, bottom: 100),
                  child: Column(
                    children: [
                      DateSelector(
                        onDateSelected: vm.weekdaySelected,
                        showMonthSelector: true,
                        highlightedWeekdays:
                            widget.schedule.roads.map((e) => e.weekDay).toSet(),
                      ),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: FutureLoader(
                          future: vm.loadRequest,
                          completeView: (context, data) {
                            if (!data) {
                              return const ErrorView(
                                  errorText: "Не удалось загрузить данные!"
                                      "\nПовторите попытку");
                            }
                            return ScheduleViewer(
                                schedule: widget.schedule,
                                selectedWeedkays: [vm.selectedWeekday],
                                hasCheckBox: widget.scheduleCheckerScreenType !=
                                    ScheduleCheckerScreenType.edit,
                                selectedRoads: vm.idRoads,
                                roadSelected: vm.roadSelected);
                          },
                          errorView: (context, error) =>
                              ErrorView(errorText: error.toString()),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                )),
              ),
            ],
          ),
          Positioned(
            bottom: 51,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: buttonAction,
              style: NannyButtonStyles.main,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
