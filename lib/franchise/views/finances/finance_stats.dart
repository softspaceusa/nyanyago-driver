import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/franchise/view_models/finance_stats_vm.dart';

class FinanceStatsView extends StatefulWidget {
  const FinanceStatsView({super.key});

  @override
  State<FinanceStatsView> createState() => _FinanceStatsViewState();
}

class _FinanceStatsViewState extends State<FinanceStatsView> with AutomaticKeepAliveClientMixin{
  late FinanceStatsVM vm;

  @override
  void initState() {
    super.initState();
    vm = FinanceStatsVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      
          const SizedBox(height: 20),
          Image.asset('packages/nanny_components/assets/images/card.png', height: 250),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  ),
                  checkColor: Colors.transparent,
                  title: Text("Расходы", style: Theme.of(context).textTheme.labelLarge),
                  value: vm.expensesSelected, 
                  activeColor: NannyTheme.primary,
                  onChanged: (value) => vm.changeSelection(true),
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  ),
                  checkColor: Colors.transparent,
                  title: Text("Зачисления", style: Theme.of(context).textTheme.labelLarge),
                  value: !vm.expensesSelected, 
                  activeColor: NannyTheme.primary,
                  onChanged: (value) => vm.changeSelection(false),
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.maxFinite,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vm.moneySpended, style: Theme.of(context).textTheme.headlineMedium),
                    Text( "${vm.expensesSelected ? "Расходы" : "Зачисления"} за "
                      "${DateFormat(DateFormat.MONTH).format(vm.selectedMonth)}" 
                    )
                  ],
                ),
              ),
            ),
          ),
          MonthSelector(
            onMonthChanged: vm.monthSelected,
          ),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Категории", style: Theme.of(context).textTheme.titleMedium),
                      const Divider(color: NannyTheme.onSecondary)
                    ],
                  ),
                ),
              )
            )
          ),
          
        ],
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}