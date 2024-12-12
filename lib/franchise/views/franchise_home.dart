import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/franchise/view_models/franchise_home_vm.dart';
import 'package:nanny_driver/franchise/views/driver_management/driver_management.dart';
import 'package:nanny_driver/franchise/views/driver_payments.dart';
import 'package:nanny_driver/franchise/views/finances/franchise_finances.dart';
import 'package:nanny_driver/franchise/views/settings/franchise_settings.dart';
import 'package:nanny_driver/views/reg.dart';

class FranchiseHomeView extends StatefulWidget {
  const FranchiseHomeView({super.key});

  @override
  State<FranchiseHomeView> createState() => _FranchiseHomeViewState();
}

class _FranchiseHomeViewState extends State<FranchiseHomeView> {
  late FranchiseHomeVM vm;

  final List<PanelButtonData> data = [
    //if (NannyUser.userInfo!.role.contains(UserType.franchiseAdmin))
    //  PanelButtonData(
    //      label: "Просмотр статистики и отчетов",
    //      imgPath: "files.png",
    //      nextView: const StatsView()),
    PanelButtonData(
        label: "Управление выплатами водителям",
        imgPath: "card.png",
        nextView: const DriverPaymentsView()),
    if (NannyUser.userInfo!.role.contains(UserType.franchiseAdmin) ||
        NannyUser.userInfo!.role.contains(UserType.manager))
      PanelButtonData(
          label: "Панель управления водителями",
          imgPath: "bike.png",
          nextView: const DriverManagementView()),
    if (NannyUser.userInfo!.role.contains(UserType.franchiseAdmin))
      PanelButtonData(
          label: "Панель управления финансами",
          imgPath: "money.png",
          nextView: const FranchiseFinancesView()),
    //if (NannyUser.userInfo!.role.contains(UserType.franchiseAdmin))
    //  PanelButtonData(
    //      label: "Панель управления настройками",
    //      imgPath: "clipboard.png",
    //      nextView: const FranchiseSettingsView()),
  ];

  @override
  void initState() {
    super.initState();
    vm = FranchiseHomeVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NannyTheme.secondary,
      appBar: NannyAppBar(
        title: "Панель управления",
        color: NannyTheme.secondary,
        hasBackButton: false,
        leading: ProfileIconButton(
          logoutView: WelcomeView(
            regView: const RegView(),
            loginPaths: NannyConsts.availablePaths,
          ),
        ),
      ),
      body: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 15, right: 16, left: 16),
          itemBuilder: (context, index) {
            List<MapEntry<int, PanelButtonData>> entries =
                data.asMap().entries.toList();
            return PanelButton(
              data: entries[index].value,
              style: entries[index].key.isEven
                  ? NannyButtonStyles.lightGreen
                  : NannyButtonStyles.whiteButton,
              onPressed: () => vm.navigateToView(data[index].nextView),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemCount: data.asMap().entries.length),
    );
  }
}
