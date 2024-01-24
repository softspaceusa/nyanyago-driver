import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/view_models/pages/balance_vm.dart';

class BalanceView extends StatefulWidget {
  final bool persistState;
  
  const BalanceView({
    super.key,
    required this.persistState,
  });

  @override
  State<BalanceView> createState() => _BalanceViewState();
}

class _BalanceViewState extends State<BalanceView> with AutomaticKeepAliveClientMixin {
  late BalanceVM vm;

  @override
  void initState() {
    super.initState();
    vm = BalanceVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    if(wantKeepAlive) super.build(context);
    
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          hasBackButton: false,
          isTransparent: false,
          title: "Баланс ",
        ),
        body: RequestLoader(
          request: vm.getMoney,
          completeView: (context, data) => RefreshIndicator(
            onRefresh: () async => vm.updateState(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                
                    const SizedBox(height: 20),
                    const Text("Текущий баланс:"),
                    Text("${data!.balance} Р", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        ElevatedButton( 
                          onPressed: vm.toPay,
                          child: const Text(
                            "Вывести денежные средства", 
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton( 
                          onPressed: vm.toCashback,
                          child: const Text(
                            "Кэшбек",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                
                  ],
                ),
              ),
            ),
          ),
          errorView: (context, error) => ErrorView(errorText: error.toString()),
        ),
      )
    );
  }
  
  @override
  bool get wantKeepAlive => widget.persistState;
}