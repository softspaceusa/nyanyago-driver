import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/view_models/home_vm.dart';
import 'package:nanny_driver/views/pages/balance.dart';
import 'package:nanny_driver/views/pages/contracts_and_schedule/info_page.dart';
import 'package:nanny_driver/views/pages/offers.dart';
import 'package:nanny_driver/views/reg.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeVM vm;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    vm = HomeVM(context: context, update: setState);
    pages = [
      const OffersView(persistState: true),
      const InfoPageView(),
      const BalanceView(persistState: true),
      const ChatsView(persistState: false),
      ProfileView(
        persistState: true,
        logoutView: WelcomeView(
          regView: const RegView(), 
          loginPaths: NannyConsts.availablePaths
        ),
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 1,
        length: pages.length,
        child: Scaffold(
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
          bottomNavigationBar: TabBar(
            onTap: (index) => vm.indexChanged(index),
      
            labelColor: NannyTheme.primary,
            unselectedLabelColor: NannyTheme.darkGrey,
            indicatorColor: NannyTheme.primary,
            tabs: const [
              Tab(
                icon: Icon(
                  Icons.directions_car_filled_rounded,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.calendar_month_rounded,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.wallet_rounded,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.chat_rounded,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.account_circle_rounded,
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}