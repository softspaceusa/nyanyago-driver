import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/pages/contracts_and_schedule/info_page_vm.dart';
import 'package:nanny_driver/views/pages/contracts_and_schedule/active_contracts.dart';
import 'package:nanny_driver/views/pages/contracts_and_schedule/driver_schedule.dart';

class InfoPageView extends StatefulWidget {
  const InfoPageView({super.key});

  @override
  State<InfoPageView> createState() => _InfoPageViewState();
}

class _InfoPageViewState extends State<InfoPageView> {
  late InfoPageVM vm;

  @override
  void initState() {
    super.initState();
    vm = InfoPageVM(context: context, update: setState);
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
              title: "Мои контракты",
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => vm.changeShowContract(true), 
                              style: vm.showContracts ? null : NannyButtonStyles.whiteButton,
                              child: const Text("Активные контракты", textAlign: TextAlign.center)
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => vm.changeShowContract(false), 
                              style: vm.showContracts ? NannyButtonStyles.whiteButton : null,
                              child: const Text("Расписание на сегодня", textAlign: TextAlign.center)
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 10),
                      NannyBottomSheet(
                        height: size.height * .6,
                        child: vm.showContracts ? const ActiveContractsView() : const DriverScheduleView()
                      ),
                    ],
                  ),
                ),
          
              ],
            ),
          );
        }
      ),
    );
  }
}