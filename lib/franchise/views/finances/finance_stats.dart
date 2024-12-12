import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/franchise/view_models/finance_stats_vm.dart';

class FinanceStatsView extends StatefulWidget {
  const FinanceStatsView({super.key});

  @override
  State<FinanceStatsView> createState() => _FinanceStatsViewState();
}

class _FinanceStatsViewState extends State<FinanceStatsView>
    with AutomaticKeepAliveClientMixin {
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
      child: RequestLoader(
        key: ValueKey(vm.selectedMonth),
        request: vm.financeStats,
        completeView: (context, data) {
          final amount = vm.expensesSelected
              ? data?.minus.total ?? 0
              : data?.plus.total ?? 0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'packages/nanny_components/assets/images/card.png',
                height: 250,
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      checkColor: Colors.transparent,
                      title: Text(
                        "Расходы",
                        style: TextStyle(
                          fontSize: 16,
                          height: 17.6 / 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF212121).withOpacity(.75),
                        ),
                      ),
                      value: vm.expensesSelected,
                      activeColor: NannyTheme.primary,
                      onChanged: (value) => vm.changeSelection(true),
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      checkColor: Colors.transparent,
                      title: Text(
                        "Зачисления",
                        style: TextStyle(
                          fontSize: 16,
                          height: 17.6 / 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF212121).withOpacity(.75),
                        ),
                      ),
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
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.formatCurrency(amount),
                          style: const TextStyle(
                            fontSize: 25,
                            height: 34.1 / 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2B2B2B),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${vm.expensesSelected ? "Расходы" : "Зачисления"} за "
                          "${DateFormat(DateFormat.MONTH, "ru").format(vm.selectedMonth)}",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              MonthSelector(
                  selectedMonth: vm.selectedMonth,
                  onMonthChanged: vm.monthSelected),
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Категории",
                            style: TextStyle(
                              fontSize: 18,
                              height: 20 / 18,
                              fontWeight: FontWeight.w600,
                              color: NannyTheme.onSecondary,
                            ),
                          ),
                          const Divider(color: NannyTheme.onSecondary),
                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  String title = vm.expensesSelected
                                      ? [
                                          'Выплата зарабтотной платы',
                                          'Начисление бонусов'
                                        ][index]
                                      : [
                                          'Пополнение баланса',
                                          'Получение комиссии'
                                        ][index];
                                  String trailing = vm.formatCurrency(
                                      vm.expensesSelected
                                          ? [
                                                data?.minus.spendingOnDrivers,
                                                data?.minus.spendingOnBonuses
                                              ][index] ??
                                              0
                                          : [
                                                data?.plus.spendingOnDrivers,
                                                data?.plus.spendingOnBonuses
                                              ][index] ??
                                              0);
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minLeadingWidth: 0,
                                    minTileHeight: 0,
                                    minVerticalPadding: 0,
                                    title: Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    trailing: Text(
                                      trailing,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: NannyTheme.primary),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      height: 17,
                                      child: const Divider(
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                itemCount: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        errorView: (context, error) => Center(
          child: ErrorView(
            errorText: "Ошибка: ${error.toString()}",
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
