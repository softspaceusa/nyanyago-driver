import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    //PanelButtonData(
    //  label: "Кошелек",
    //  imgPath: "clipboard.png",
    //  nextView: const WalletView(
    //    title: "Карты",
    //    subtitle: "Ваши карты",
    //  ),
    //),
    //PanelButtonData(
    //  label: "Отчет вывода денег",
    //  imgPath: "money.png",
    //  nextView: const MoneyHistoryView(),
    //),
  ];

  @override
  void initState() {
    super.initState();
    vm = PartnerHomeVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: NannyTheme.secondary,
        appBar: NannyAppBar(
          title: "Панель управления",
          color: NannyTheme.secondary,
          isTransparent: true,
          hasBackButton: false,
          leading: IconButton(
              onPressed: vm.navigateToProfile,
              icon: const Icon(Icons.account_circle),
              iconSize: 25),
        ),
        body: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 15, right: 16, left: 16),
            itemBuilder: (context, index) {
              List<MapEntry<int, PanelButtonData>> entries =
                  data.asMap().entries.toList();
              return PanelButton(
                data: entries[index].value,
                style: entries[index].key.isOdd
                    ? NannyButtonStyles.lightGreen
                    : NannyButtonStyles.whiteButton,
                onPressed: () => vm.navigateToView(data[index].nextView),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemCount: data.asMap().entries.length),
      ),
    );
  }
}
