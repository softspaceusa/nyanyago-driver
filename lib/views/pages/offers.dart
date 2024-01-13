import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/view_models/pages/offers_vm.dart';

class OffersView extends StatefulWidget {
  const OffersView({super.key});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  late OffersVM vm;

  @override
  void initState() {
    super.initState();
    vm = OffersVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          hasBackButton: false,
          title: "Список предложений",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
          
              Image.asset(
                'packages/nanny_components/assets/images/offers.png',
                height: 200,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [

                      switchButton(offerType: OfferType.route),
                      const SizedBox(width: 20),
                      switchButton(offerType: OfferType.oneTime),
                      const SizedBox(width: 20),
                      switchButton(offerType: OfferType.replacement),

                    ],
                  ),
                ),
              ),
              ListView( // TODO: Доделать предложения!
                shrinkWrap: true,
                children: [

                ],
              ),
             
            ],
          ),
        ),
      )
    );
  }

  Widget switchButton({
    required OfferType offerType,
  }) {
    return ElevatedButton(
      style: vm.selectedOfferType == offerType ? null : NannyButtonStyles.whiteButton,
      
      onPressed: () => vm.changeOfferType(offerType), 
      child: Text(offerType.name)
    );
  }
}