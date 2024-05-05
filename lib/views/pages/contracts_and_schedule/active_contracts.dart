import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
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
        return const Center(
          child: Text("У вас пока что нет активных контрактов..."),
        );
      }, 
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }
}