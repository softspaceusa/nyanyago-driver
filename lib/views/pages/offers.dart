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

    return SafeArea(
        child: Scaffold(
            appBar: const NannyAppBar(
                hasBackButton: false, title: "Список предложений"),
            body: Stack(children: [
              Column(children: [
                CupertinoButton(
                  onPressed: () {
                    vm.updateStatuses();
                  },
                  child: Image.asset(
                      'packages/nanny_components/assets/images/offers.png',
                      height: 100),
                ),
                SizedBox(
                    height: 88,
                    width: double.infinity,
                    child: RefreshIndicator(
                      onRefresh: vm.loadOneTimeDrives,
                      child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(20),
                          scrollDirection: Axis.horizontal,
                          children: [
                            switchButton(offerType: OfferType.route),
                            const SizedBox(width: 20),
                            switchButton(offerType: OfferType.oneTime),
                            const SizedBox(width: 20),
                            switchButton(offerType: OfferType.replacement)
                          ]),
                    )),
                Expanded(
                    child: FutureLoader(
                        future: vm.loadRequest,
                        completeView: (context, data) {
                          // if(!data) {
                          //   return const ErrorView(errorText: "Не удалось загрузить даные!");
                          // }

                          return ListView(
                              // TODO: Доделать предложения!
                              padding: const EdgeInsets.only(bottom: 140),
                              shrinkWrap: true,
                              children: vm.selectedOfferType ==
                                          OfferType.oneTime ||
                                      vm.selectedOfferType ==
                                          OfferType.replacement
                                  ? vm.oneTimeDrive
                                      .map((e) => OneTimeDriveWidget(
                                          e,
                                          vm.setSelected,
                                          vm.selectedId == e.orderId))
                                      .toList()
                                  : vm.offers
                                      .map((e) => listItemWidget(e))
                                      .toList());
                        },
                        errorView: (context, error) =>
                            ErrorView(errorText: error.toString()))),
              ]),
              Visibility(
                  visible: vm.selectedId != 0,
                  child: Positioned(
                      bottom: 80,
                      left: 20,
                      right: 20,
                      child: ElevatedButton(
                          onPressed: vm.onAccept,
                          child: const Text('Начать поездку')))),
              Visibility(
                  visible: vm.selectedId != 0,
                  child: Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Theme(
                          data: Theme.of(context).copyWith(
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                          backgroundColor:
                                              const WidgetStatePropertyAll(
                                                  Colors.white)))),
                          child: ElevatedButton(
                              onPressed: vm.onCancel,
                              child: Text('Отклонить',
                                  style: NannyTextStyles.defaultTextStyle
                                      .copyWith(color: Colors.black))))))
            ])));
  }

  Widget switchButton({
    required OfferType offerType,
  }) {
    return ElevatedButton(
        style: vm.selectedOfferType == offerType
            ? null
            : NannyButtonStyles.whiteButton,
        onPressed: () => vm.changeOfferType(offerType),
        child: Text(offerType.name));
  }

  Widget clientProfile(DriverScheduleResponse schedule) {
    return ListTile(
      leading: SizedBox(
          height: 60,
          width: 60,
          child: ProfileImage(
            url: schedule.user.photoPath,
            radius: 50,
            padding: EdgeInsets.zero,
          )),
      title: Text(schedule.user.name),
      subtitle: Text("Детей: ${schedule.childrenCount}"),
      // trailing: Card(
      //   color: NannyTheme.lightGreen,
      //   child: Text(schedule.),
      // ),
    );
  }

  Widget listItemWidget(DriverScheduleResponse e) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
            onTap: () => vm.navigateToView(ScheduleCheckerView(schedule: e)),
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      clientProfile(e),
                      SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: e.roads
                                  .map((road) => Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 8,
                                                offset: Offset(2, 2),
                                                color: Colors.black12)
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(road.weekDay.fullName),
                                            Text(
                                                "${road.startTime.formatTime()} - ${road.endTime.formatTime()}")
                                          ])))
                                  .toList())),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: vm.params.toSet().map((param) {
                            var widget = otherParamWidget(param,
                                e.otherParametrs.any((e) => e.id == param.id));
                            if (widget != null) return widget;
                            return const SizedBox();
                          }).toList()),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Стоимость одного маршрута: ",
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                          Text('${e.salaryRoad?.toStringAsFixed(1) ?? '0.0'}₽',
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w400))
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Общая стоимость: ",
                              style: NannyTextStyles.defaultTextStyle
                                  .copyWith(fontSize: 18)),
                          Text('${e.allSalary.toStringAsFixed(1)}₽',
                              style: NannyTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 25, fontWeight: FontWeight.w700))
                        ],
                      )
                    ])))));
  }

  Widget? otherParamWidget(OtherParametr param, bool selected) {
    return selected
        ? Padding(
            padding: const EdgeInsets.only(left: 20, top: 12),
            child: Row(children: [
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
                            ))),
              const SizedBox(width: 10),
              Text(param.title ?? '',
                  style: NannyTextStyles.nw40018
                      .copyWith(fontSize: 16, color: Colors.black))
            ]))
        : null;
  }

  // List<DriverScheduleResponse> testSched = [
  //   DriverScheduleResponse(
  //     title: "title",
  //     duration: 30,
  //     childrenCount: 2,
  //     weekdays: [NannyWeekday.monday],
  //     tariff: DriveTariff(id: 0, title: "Tariff"),
  //     otherParametrs: [OtherParametr(id: 1, title: "Переодеть")],
  //     roads: [Road(
  //       weekDay: NannyWeekday.monday,
  //       startTime: TimeOfDay(hour: 12, minute: 10),
  //       endTime: TimeOfDay(hour: 13, minute: 0),
  //       addresses: [DriveAddress(
  //         fromAddress: AddressData(
  //           address: "address",
  //           location: LatLng(0, 0)
  //         ),
  //         toAddress: AddressData(
  //           address: "address",
  //           location: LatLng(0, 0)
  //         ),
  //       )],
  //       title: "Road title",
  //       typeDrive: [
  //         DriveType.oneWay
  //       ]
  //     ),
  //     Road(
  //       weekDay: NannyWeekday.monday,
  //       startTime: TimeOfDay(hour: 12, minute: 10),
  //       endTime: TimeOfDay(hour: 13, minute: 0),
  //       addresses: [DriveAddress(
  //         fromAddress: AddressData(
  //           address: "address",
  //           location: LatLng(0, 0)
  //         ),
  //         toAddress: AddressData(
  //           address: "address",
  //           location: LatLng(0, 0)
  //         ),
  //       )],
  //       title: "Road title",
  //       typeDrive: [
  //         DriveType.oneWay
  //       ]
  //     )],
  //     user: ScheduleUser(
  //       idUser: 1,
  //       name: "name",
  //       photoPath: "photoPath"
  //     ),
  //     allSalary: 150
  //   )
  // ];

  @override
  bool get wantKeepAlive => widget.persistState;
}
