import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/one_time_drive_widget.dart';
import 'package:nanny_core/enums.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/view_models/pages/offers_vm.dart';
import 'package:nanny_driver/views/schedule_checker.dart';

class OffersView extends StatefulWidget {
  final bool persistState;

  const OffersView({
    super.key,
    required this.persistState,
  });

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView>
    with AutomaticKeepAliveClientMixin {
  late OffersVM vm;

  @override
  void initState() {
    super.initState();
    vm = OffersVM(context: context, update: setState)..load();
  }

  @override
  Widget build(BuildContext context) {
    if (wantKeepAlive) super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FF),
      appBar: const NannyAppBar(
          color: Color(0xFFF6F5FF),
          hasBackButton: false,
          title: "Список предложений"),
      body: Stack(
        children: [
          Column(children: [
            CupertinoButton(
              onPressed: () {
                vm.updateStatuses();
              },
              child: Image.asset(
                  'packages/nanny_components/assets/images/offers.png',
                  height: 213),
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: RefreshIndicator(
                onRefresh: vm.loadOneTimeDrives,
                child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final offer = OfferType.values[index];
                      return ElevatedButton(
                        onPressed: () => vm.changeOfferType(offer),
                        style: (vm.selectedOfferType == offer
                                ? NannyButtonStyles.main
                                : NannyButtonStyles.secondary)
                            .copyWith(
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 20),
                          ),
                          minimumSize: const WidgetStatePropertyAll(
                            Size(0, 40),
                          ),
                        ),
                        child: Text(offer.name),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemCount: 2),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureLoader(
                future: vm.loadRequest,
                completeView: (context, data) {
                  // if(!data) {
                  //   return const ErrorView(errorText: "Не удалось загрузить даные!");
                  // }

                  return vm.selectedOfferType == OfferType.oneTime ||
                          vm.selectedOfferType == OfferType.replacement
                      ? vm.oneTimeDrive.isNotEmpty
                          ? ListView.separated(
                              padding: const EdgeInsets.only(bottom: 140),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = vm.oneTimeDrive[index];
                                return OneTimeDriveWidget(item, vm.setSelected,
                                    vm.selectedId == item.orderId);
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemCount: vm.oneTimeDrive.length)
                          : const Center(
                              child: Text("Нет данных..."),
                            )
                      : vm.offers
                              .isNotEmpty // Здесь можно заменить 5 на реальное количество элементов, если нужно
                          ? ListView.separated(
                              padding: const EdgeInsets.only(bottom: 140),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = vm.offers[index];
                                return ScheduleWidget(
                                    onTap: () => vm.navigateToView(
                                          ScheduleCheckerView(
                                              schedule: item,
                                              scheduleCheckerScreenType:
                                                  ScheduleCheckerScreenType
                                                      .response),
                                        ),
                                    schedule: item,
                                    allParams: vm.params);
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemCount: vm.offers.length)
                          : const Center(
                              child: Text("Нет данных..."),
                            );
                },
                errorView: (context, error) => ErrorView(
                  errorText: error.toString(),
                ),
              ),
            ),
          ]),
          Visibility(
            visible: vm.selectedId != 0,
            child: Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: vm.onAccept,
                style: NannyButtonStyles.main,
                child: const Text('Начать поездку'),
              ),
            ),
          ),
          Visibility(
            visible: vm.selectedId != 0,
            child: Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: vm.onCancel,
                style: NannyButtonStyles.secondary,
                child: const Text('Отклонить'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.persistState;
}
