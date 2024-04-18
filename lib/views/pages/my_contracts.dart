import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/pages/my_contracts_vm.dart';
import 'package:nanny_components/widgets/today_schedule_view.dart';

class MyContractsView extends StatefulWidget {
  const MyContractsView({super.key});

  @override
  State<MyContractsView> createState() => _MyContractsViewState();
}

class _MyContractsViewState extends State<MyContractsView> {
  late MyContractsVM vm;

  @override
  void initState() {
    super.initState();
    vm = MyContractsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AdaptBuilder(
        builder: (context, size) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: const NannyAppBar(
              hasBackButton: false,
              title: "Активные контракты",
            ),
            body: Stack(
              children: [
                
                Padding(
                  padding: const EdgeInsets.only(left: 100, top: 50, right: 100),
                  child: Image.asset(
                    'packages/nanny_components/assets/images/travel.png',
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: NannyBottomSheet(
                    height: size.height * .6,
                    child: FutureLoader(
                      future: vm.loadRequest, 
                      completeView: (context, data) {
                        if(!data) return const ErrorView(errorText: "Не удалось загрузить данные!");
                    
                        if(vm.schedules.isEmpty) {
                          return const Center(
                            child: Text("Контрактов на сегодня нет..."),
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
                    ),
                  ),
                )
          
              ],
            ),
          );
        }
      ),
    );
  }
}