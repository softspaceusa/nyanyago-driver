import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_driver/franchise/view_models/driver_management/tariffs_vm.dart';
import 'package:nanny_components/widgets/tariffs/tariff_item.dart';

class TarifsView extends StatefulWidget {
  const TarifsView({super.key});

  @override
  State<TarifsView> createState() => _TarifsViewState();
}

class _TarifsViewState extends State<TarifsView>
    with AutomaticKeepAliveClientMixin {
  late TariffsVM vm;
  PageController pageController = PageController(viewportFraction: 1.05);

  @override
  void initState() {
    super.initState();
    vm = TariffsVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RequestLoader(
      request: vm.request,
      completeView: (context, data) {
        if (data == null || data.isEmpty) {
          return const Center(child: Text("На данный момент тарифов нет..."));
        }

        List<DriveTariff> oneTimeTrips = data.where((e) => e.oneTime).toList();
        List<DriveTariff> dailyTrips = data.where((e) => !e.oneTime).toList();

        return RefreshIndicator(
          onRefresh: () async => vm.reloadView(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 33),
                  shrinkWrap: true,
                  children: [
                    TariffItem(
                        isOneTimeTrips: true,
                        pageController: pageController,
                        tariffs: oneTimeTrips),
                    if (dailyTrips.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                            top: oneTimeTrips.isNotEmpty ? 10 : 0),
                        child: TariffItem(
                            isOneTimeTrips: false,
                            pageController: pageController,
                            tariffs: dailyTrips),
                      ),
                  ],
                ),
              ),
              //NannyBottomSheet(
              //  child: Padding(
              //    padding: const EdgeInsets.all(10),
              //    child: Column(
              //      children: [
              //        FloatingActionButton(
              //          onPressed: vm.addTariff,
              //          child: const Icon(Icons.add),
              //        ),
              //        const Text("Добавить тариф")
              //      ],
              //    ),
              //  ),
              //)
            ],
          ),
        );
      },
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
