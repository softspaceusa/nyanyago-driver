import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/pages/balance_vm.dart';

class BalanceView extends StatefulWidget {
  const BalanceView({super.key});

  @override
  State<BalanceView> createState() => _BalanceViewState();
}

class _BalanceViewState extends State<BalanceView> {
  late BalanceVM vm;

  @override
  void initState() {
    super.initState();
    vm = BalanceVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RequestLoader(
          request: vm.getMoney,
          completeView: (context, data) => RefreshIndicator(
            onRefresh: () async => vm.updateState(),
            child: Column(
              children: [

                const SizedBox(height: 20),
                const Text("Текущий баланс:"),
                Text(data!.balance.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton(
                  onPressed: vm.navigateToWallet,
                  child: const Text("Вывести денежные средства"),
                ),
            
              ],
            ),
          ),
          errorView: (context, error) => ErrorView(errorText: error.toString()),
        ),
      )
    );
  }
}