import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/franchise/view_models/franchise_home_vm.dart';
import 'package:nanny_driver/franchise/views/driver_management/driver_management.dart';
import 'package:nanny_driver/franchise/views/driver_payments.dart';
import 'package:nanny_driver/franchise/views/stats.dart';
import 'package:nanny_driver/views/reg.dart';

class FranchiseHomeView extends StatefulWidget {
  const FranchiseHomeView({super.key});

  @override
  State<FranchiseHomeView> createState() => _FranchiseHomeViewState();
}

class _FranchiseHomeViewState extends State<FranchiseHomeView> {
  late FranchiseHomeVM vm;

  final List<PanelButtonData> data = [
    PanelButtonData(
      label: "Просмотр статистики и отчетов",
      imgPath: "files.png",
      nextView: const StatsView()
    ),
    PanelButtonData(
      label: "Управление выплатами водителям",
      imgPath: "card.png",
      nextView: const DriverPaymentsView()
    ),
    PanelButtonData(
      label: "Панель управления водителями",
      imgPath: "bike.png",
      nextView: const DriverManagementView()
    ),
    PanelButtonData(
      label: "Панель управления финансами",
      imgPath: "money.png",
      nextView: const Placeholder()
    ),
    PanelButtonData(
      label: "Панель управления настройками",
      imgPath: "clipboard.png",
      nextView: const Placeholder()
    ),
  ];

  @override
  void initState() {
    super.initState();
    vm = FranchiseHomeVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NannyAppBar(
          hasBackButton: false,
          title: "Панель управления",
          leading: ProfileIconButton(
            logoutView: WelcomeView(
              regView: const RegView(),
              loginPaths: NannyConsts.availablePaths,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: data.asMap().entries.map(
            (e) => panelButton(
              e.value, 
              e.key.isEven ? NannyButtonStyles.lightGreen : NannyButtonStyles.whiteButton,
            ),
          ).toList(),
        ),
      ),
    );
  }

  Widget panelButton(PanelButtonData data, ButtonStyle style) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          style: style,
          onPressed: () => vm.navigateToView(data.nextView), 
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(data.label)),
                Image.asset(
                  'packages/nanny_components/assets/images/${data.imgPath}',
                  width: 100,
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class PanelButtonData {
  PanelButtonData({
    required this.label,
    required this.imgPath,
    required this.nextView
  });

  final String label;
  final String imgPath;
  final Widget nextView;
}