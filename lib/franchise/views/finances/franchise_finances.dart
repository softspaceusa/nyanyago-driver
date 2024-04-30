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
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: NannyAppBar(
            isTransparent: false,
            title: "Управление финансами",
            bottom: TabBar(
              indicatorColor: NannyTheme.primary,
              labelColor: NannyTheme.primary,
              unselectedLabelColor: NannyTheme.onSecondary,
              splashBorderRadius: BorderRadius.circular(30),
              indicator: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(
                    width: 4,
                    color: NannyTheme.primary
                  )
                ),
                borderRadius: BorderRadius.circular(30)
              ),
              tabs: const [
                Tab(
                  text: "Список водителей",
                ),
                Tab(
                  text: "Статистика",
                ),
              ]
            ),
          ),
          body: TabBarView(
            children: [

              FranchiseDriverList<String>(
                showNewDrivers: false,
                
                filterItems: [],
                itemLabel: (item) => item, 
                onItemChanged: (item) {}, 
                onDriverTap: (user) => vm.navigateToView(
                  DriverInfoView(
                    id: user.id,
                    franchiseView: true,
                  )
                ),
              ),
              const FinanceStatsView(),

            ]
          ),
        ),
      ),
    );
  }
}