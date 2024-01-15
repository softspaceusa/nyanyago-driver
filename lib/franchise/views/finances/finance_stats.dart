import 'package:flutter/material.dart';
import 'package:nanny_driver/franchise/view_models/finance_stats_vm.dart';

class FinanceStatsView extends StatefulWidget {
  const FinanceStatsView({super.key});

  @override
  State<FinanceStatsView> createState() => _FinanceStatsViewState();
}

class _FinanceStatsViewState extends State<FinanceStatsView> {
  late FinanceStatsVM vm;

  @override
  void initState() {
    super.initState();
    vm = FinanceStatsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 20),
        Image.asset('packages/nanny_components/assets/images/card.png'),
        Row(
          children: [
            CheckboxListTile(
              title: const Text("Расходы"),
              value: vm.expensesSelected, 
              onChanged: (value) => vm.changeSelection(true),
            ),
            CheckboxListTile(
              title: const Text("Зачисления"),
              value: !vm.expensesSelected, 
              onChanged: (value) => vm.changeSelection(false),
            ),
          ],
        ),
        Card(
          child: Column(
            children: [
              Text(vm.moneySpended),
              const Text("")
            ],
          ),
        )
        
      ],
    );
  }
}