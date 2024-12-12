import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/admin_part/view_models/finance_management_vm.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class FinanceManagementView extends StatefulWidget {
  const FinanceManagementView({super.key});

  @override
  State<FinanceManagementView> createState() => _FinanceManagementViewState();
}

class _FinanceManagementViewState extends State<FinanceManagementView> {
  late FinanceManagementVM vm;

  @override
  void initState() {
    super.initState();
    vm = FinanceManagementVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NannyAppBar(
            title: "Управление финансами",
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: SegmentedButton<DateType>(
                style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: NannyTheme.lightGreen,
                    disabledForegroundColor: NannyTheme.onSecondary),
                showSelectedIcon: false,
                segments: DateType.values
                    .map((e) => ButtonSegment<DateType>(
                        value: e,
                        label: Text(e.name),
                        enabled: e != vm.selectedDateType.first))
                    .toList(),
                selected: vm.selectedDateType,
                onSelectionChanged: vm.onDateTypeSelect,
              ),
            )),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text("Текущий баланс:"),
                RequestLoader(
                  request: vm.getMoney,
                  completeView: (context, data) => Text("${data!.balance} Р",
                      style: Theme.of(context).textTheme.titleMedium),
                  errorView: (context, error) =>
                      ErrorView(errorText: error.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Image.asset(
                      "packages/nanny_components/assets/images/card.png"),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              vm.statsSwitch(switchToWithdraw: false),
                          style: vm.withdrawSelected
                              ? NannyButtonStyles.whiteButton
                              : null,
                          child: const Text("Комиссии"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              vm.statsSwitch(switchToWithdraw: true),
                          style: vm.withdrawSelected
                              ? null
                              : NannyButtonStyles.whiteButton,
                          child: const Text("Транзакции"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height * .5),
                  child: NannyBottomSheet(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: RequestLoader(
                        request: vm.getMoney,
                        completeView: (context, data) => ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: data!.history
                              .where((el) => el.title.toLowerCase().contains(
                                  vm.withdrawSelected
                                      ? "снятие"
                                      : "пополнение"))
                              .map(
                                (e) => ListTile(
                                  leading: Text(e.title),
                                  trailing: Text("${e.amount} Р"),
                                ),
                              )
                              .toList(),
                        ),
                        errorView: (context, error) =>
                            ErrorView(errorText: error.toString()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
