import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/states/info_view.dart';
import 'package:nanny_core/constants.dart';
import 'package:nanny_driver/view_models/money_history_vm.dart';

class MoneyHistoryView extends StatefulWidget {
  const MoneyHistoryView({super.key});

  @override
  State<MoneyHistoryView> createState() => _MoneyHistoryViewState();
}

class _MoneyHistoryViewState extends State<MoneyHistoryView> {
  late MoneyHistoryVM vm;

  @override
  void initState() {
    super.initState();
    vm = MoneyHistoryVM(context: context, update: setState);
  }

  TextStyle textStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: NannyTheme.primary);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const NannyAppBar(
        color: NannyTheme.secondary,
        isTransparent: false,
        title: "Управление отчетами",
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: NannyBottomSheet(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 27, right: 16, left: 16, bottom: 27),
                child: Column(
                  children: [
                    Text(
                      'Отчет вывода денег',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        height: 20 / 18,
                        color: NannyTheme.onSecondary.withOpacity(.75),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        DateType.values.length,
                        (index) => GestureDetector(
                          onTap: () => vm.onSelect({DateType.values[index]}),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 6, bottom: 6, left: 20, right: 20),
                            decoration: BoxDecoration(
                              color:
                                  DateType.values[index] == vm.selectedDateType
                                      ? NannyTheme.lightGreen
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(49),
                            ),
                            child: Text(
                              DateType.values[index].name,
                              style: const TextStyle(height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: vm.payouts.isEmpty
                          ? const InfoView(infoText: "Ещё нет данных")
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: vm.payouts.length,
                              itemBuilder: (context, index) {
                                final payout = vm.payouts[index];
                                return ListTile(
                                  title: Text(
                                    "+${payout.money} Р",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: NannyTheme.primary),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      payout.datetimeCreate,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: NannyTheme.darkGrey),
                                    ),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: textStyle,
                                          children: [
                                            const TextSpan(text: 'Команда:'),
                                            TextSpan(
                                              text: ' 50000',
                                              style: textStyle.copyWith(
                                                color: NannyTheme.onSecondary
                                                    .withOpacity(.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      RichText(
                                        text: TextSpan(
                                          style: textStyle,
                                          children: [
                                            const TextSpan(text: '% кэшбэка:'),
                                            TextSpan(
                                              text:
                                                  ' ${payout.cashbackPercent}',
                                              style: textStyle.copyWith(
                                                color: NannyTheme.onSecondary
                                                    .withOpacity(.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                child: Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: NannyTheme.grey),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
