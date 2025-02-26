import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/one_time_drive_widget.dart';
import 'package:nanny_core/models/from_api/drive_and_map/driver_schedule_response.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
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
                          : const Expanded(
                              child: Center(
                                child: Text("Нет данных..."),
                              ),
                            )
                      : vm.offers
                              .isNotEmpty // Здесь можно заменить 5 на реальное количество элементов, если нужно
                          ? ListView.separated(
                              padding: const EdgeInsets.only(bottom: 140),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = vm.offers[index];
                                return listItemWidget(item);
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemCount: vm.offers.length)
                          : const Expanded(
                              child: Center(
                                child: Text("Нет данных..."),
                              ),
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

  Widget clientProfile(DriverScheduleResponse schedule) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        height: 55,
        width: 55,
        child: ProfileImage(
          url: schedule.user.photoPath,
          radius: 55 / 2,
          padding: EdgeInsets.zero,
        ),
      ),
      title: Text(
        schedule.user.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        getChildrenText(schedule.childrenCount),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget listItemWidget(DriverScheduleResponse e) {
    return GestureDetector(
      onTap: () => vm.navigateToView(
        ScheduleCheckerView(schedule: e),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: NannyTheme.secondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: NannyTheme.secondary,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 32,
                color: const Color(0xFF605B99).withOpacity(.19),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12),
                    child: clientProfile(e),
                  ),
                  SizedBox(
                    height: 81,
                    width: double.infinity,
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final road = e.roads[index];
                          return Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 11,
                                  offset: const Offset(0, 4),
                                  color:
                                      const Color(0xFF021C3B).withOpacity(.12),
                                )
                              ],
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  road.weekDay.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF2B2B2B),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  "${road.startTime.formatTime()} - ${road.endTime.formatTime()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xFF2B2B2B),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemCount: e.roads.length),
                  ),
                  const SizedBox(height: 7),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: vm.params.toSet().map((param) {
                        var widget = otherParamWidget(
                          param,
                          e.otherParametrs.any((e) => e.id == param.id),
                        );
                        if (widget != null) return widget;
                        return const SizedBox();
                      }).toList()),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Стоимость одного маршрута: ",
                          style: NannyTextStyles.defaultTextStyle.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          formatCurrency(e.salaryRoad ?? 0),
                          style: NannyTextStyles.defaultTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: ''),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Общая стоимость: ",
                          style: NannyTextStyles.defaultTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          formatCurrency(e.allSalary),
                          style: NannyTextStyles.defaultTextStyle.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: ''),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(right: 16, top: 16, child: durationChip(e.duration)),
            ],
          ),
        ),
      ),
    );
  }

  Widget durationChip(int duration) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: NannyTheme.lightGreen),
          child: Text(
            duration == 365
                ? 'Годовой'
                : duration == 30
                    ? 'Месячный'
                    : duration == 7
                        ? 'Недельный'
                        : 'N/A',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF2B2B2B),
            ),
          ),
        ),
      ],
    );
  }

  Widget? otherParamWidget(OtherParametr param, bool selected) {
    return selected
        ? Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Row(
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: selected ? NannyTheme.primary : Colors.white,
                    shape: BoxShape.circle,
                    border: selected
                        ? null
                        : Border.all(
                            color: NannyTheme.primary,
                            width: 1,
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(param.title ?? '',
                    style: NannyTextStyles.nw40018
                        .copyWith(fontSize: 16, color: Colors.black))
              ],
            ),
          )
        : null;
  }

  /// Форматирование валюты
  String formatCurrency(double value) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formatted = formatter.format(value).replaceFirst('.', ',');
    return "$formatted ₽";
  }

  String getChildrenText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return "$count ребёнок";
    } else if ([2, 3, 4].contains(count % 10) &&
        !(count % 100 >= 12 && count % 100 <= 14)) {
      return "$count детей";
    } else {
      return "$count детей";
    }
  }

  @override
  bool get wantKeepAlive => widget.persistState;
}
