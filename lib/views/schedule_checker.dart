import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/schedule_viewer.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_driver/view_models/schedule_checker_vm.dart';

class ScheduleCheckerView extends StatefulWidget {
  final Schedule schedule;
  
  const ScheduleCheckerView({
    super.key,
    required this.schedule,
  });

  @override
  State<ScheduleCheckerView> createState() => _ScheduleCheckerViewState();
}

class _ScheduleCheckerViewState extends State<ScheduleCheckerView> {
  late final ScheduleCheckerVm vm;
  
  @override
  void initState() {
    super.initState();
    vm = ScheduleCheckerVm(context: context, update: setState, schedule: widget.schedule);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NannyAppBar(),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: vm.wantSchedule, 
                child: const Text("Принять заявку")
              ),
              Expanded(
                child: CheckboxListTile(
                  title: Text("Выбрать всё", style: Theme.of(context).textTheme.bodySmall),
                  activeColor: NannyTheme.primary,
                  
                  value: vm.selectAll,
                  onChanged: vm.selectAllChanged,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 20),
          DateSelector(
            onDateSelected: vm.weekdaySelected,
            showMonthSelector: false,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: NannyBottomSheet(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: FutureLoader(
                        future: vm.loadRequest, 
                        completeView: (context, data) {
                          if(!data) {
                            return const ErrorView(
                              errorText: "Не удалось загрузить данные!"
                                "\nПовторите попытку"
                            );
                          }
                      
                          return ScheduleViewer(
                            schedule: widget.schedule, 
                            selectedWeedkay: vm.selectedWeekday,

                            hasCheckBox: true,
                            selectedRoads: vm.idRoads,
                            roadSelected: vm.roadSelected,
                          );
                        },
                        errorView: (context, error) => ErrorView(errorText: error.toString()),
                      ),
                    ),
                    // ElevatedButton.icon(
                    //   onPressed: () => vm.navigateToView(const GraphCreate()), 

                    //   icon: const Text("Добавить новый график"),
                    //   label: const Icon(Icons.arrow_forward_rounded), 
                    // ),
                    const SizedBox(height: 30),
              
                  ],
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}