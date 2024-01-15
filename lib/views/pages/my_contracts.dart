import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/pages/my_contracts_vm.dart';

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
      child: Scaffold(
        appBar: const NannyAppBar(
          hasBackButton: false,
          title: "Активные контракты",
        ),
        body: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Image.asset(
                'packages/nanny_components/assets/images/travel.png',
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
              ),
            )

          ],
        ),
      ),
    );
  }
}