import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_driver/franchise/view_models/partner/partner_home_vm.dart';

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
      imgPath: "file.png",
      nextView: const Placeholder(),
    ),
    PanelButtonData(
      label: "Кошелек",
      imgPath: "clipboard.png",
      nextView: const Placeholder(),
    ),
    PanelButtonData(
      label: "Отчет вывода денег",
      imgPath: "money.png",
      nextView: const Placeholder(),
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
        appBar: const NannyAppBar(
          hasBackButton: false,
          title: "Панель управления",
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
    return SizedBox(
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