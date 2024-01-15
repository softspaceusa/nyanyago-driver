import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';

class FranchiseFinancesView extends StatefulWidget {
  const FranchiseFinancesView({super.key});

  @override
  State<FranchiseFinancesView> createState() => _FranchiseFinancesViewState();
}

class _FranchiseFinancesViewState extends State<FranchiseFinancesView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const NannyAppBar(
            isTransparent: false,
            title: "Управление финансами",
            bottom: TabBar(
              indicatorColor: NannyTheme.primary,
              labelColor: NannyTheme.primary,
              unselectedLabelColor: NannyTheme.onSecondary,
              tabs: [
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
                filterItems: [],
                itemLabel: (item) => item, 
                onChanged: (item) {}, 
                onDriverTap: (data) {},
              ),             

            ]
          ),
        ),
      ),
    );
  }
}