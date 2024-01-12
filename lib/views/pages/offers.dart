import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
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
        appBar: NannyAppBar(
          title: "Список предложений",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset('packages/nanny_components/assets/images/')
              ],
            ),
          ),
        ),
      )
    );
  }
}