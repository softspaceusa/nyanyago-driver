import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/partner/partner_home_vm.dart';
import 'package:nanny_driver/franchise/views/partner/money_history.dart';
import 'package:nanny_driver/franchise/views/partner/my_referals.dart';

class PartnerHomeView extends StatefulWidget {
  const PartnerHomeView({super.key});

  @override
  State<PartnerHomeView> createState() => _PartnerHomeViewState();
}

class _PartnerHomeViewState extends State<PartnerHomeView> {
  late PartnerHomeVM vm;
  final List<PanelButtonData> data = [
    PanelButtonData(
      label: "Рефералы",
      imgPath: "files.png",
      nextView: const MyReferalsView(),
    ),
    PanelButtonData(
      label: "Кошелек",
      imgPath: "clipboard.png",
      nextView: const WalletView(
        title: "Карты",
        subtitle: "Ваши карты",
      ),
    ),
    PanelButtonData(
      label: "Отчет вывода денег",
      imgPath: "money.png",
      nextView: const MoneyHistoryView(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    vm = PartnerHomeVM(context: context, update: setState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NannyAppBar(
          hasBackButton: false,
          title: "Панель управления",
          leading: IconButton(
            onPressed: vm.navigateToProfile,
            icon: const Icon(Icons.account_circle),
            iconSize: 25,
          ),
        ),
        body: ListView(
          children: data.asMap().entries.map(
            (e) => panelButton(
              e.value, 
              e.key.isOdd ? NannyButtonStyles.lightGreen : NannyButtonStyles.whiteButton,
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
                Text(data.label),
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