import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/views/driver_info.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/finances/franchise_finances_vm.dart';
import 'package:nanny_driver/franchise/views/finances/finance_stats.dart';

class FranchiseFinancesView extends StatefulWidget {
  const FranchiseFinancesView({super.key});

  @override
  State<FranchiseFinancesView> createState() => _FranchiseFinancesViewState();
}

class _FranchiseFinancesViewState extends State<FranchiseFinancesView> {
  late FranchiseFinancesVM vm;

  @override
  void initState() {
    super.initState();
    vm = FranchiseFinancesVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: const NannyAppBar(
            isTransparent: false,
            title: "Управление финансами",
            color: NannyTheme.secondary),
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              TabBar(
                indicatorColor: NannyTheme.primary,
                labelColor: NannyTheme.primary,
                unselectedLabelColor: const Color(0xFF6D6D6D),
                splashBorderRadius: BorderRadius.circular(0),
                indicatorPadding:
                    const EdgeInsets.only(top: 20, left: 16, right: 16),
                labelStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(
                    text: "Список водителей",
                  ),
                  Tab(
                    text: "Статистика",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FranchiseDriverList<String>(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 37),
                      showNewDrivers: false,
                      excludeFilter: false,
                      filterItems: const ['По статусу', 'По дате'],
                      itemLabel: (item) => item,
                      onItemChanged: (item) {},
                      onDriverTap: (user) => vm.navigateToView(
                        DriverInfoView(
                          id: user.id,
                          franchiseView: true,
                        ),
                      ),
                    ),
                    const FinanceStatsView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
