import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/circular_button.dart';
import 'package:nanny_components/widgets/order_action_button.dart';
import 'package:nanny_components/widgets/one_time_drive_widget.dart';
import 'package:nanny_core/map_services/location_service.dart';
import 'package:nanny_core/map_services/nanny_map_globals.dart';
import 'package:nanny_driver/view_models/map_view_order_vm.dart';

class MapViewOrder extends StatefulWidget {
  const MapViewOrder(
      {super.key,
      required this.myLocation,
      required this.model,
      required this.orderId,
      required this.driveToken});

  final LatLng myLocation;
  final String driveToken;
  final int orderId;
  final OneTimeDriveModel model;

  @override
  State<MapViewOrder> createState() => _MapViewOrderState();
}

class _MapViewOrderState extends State<MapViewOrder> {
  final sheetController = DraggableScrollableController();
  double _sheetPosition = 0.5;
  Set<Marker> markers = {};
  String driverAddress = '';
  late final MapViewOrderVm vm;

  @override
  void initState() {
    super.initState();
    vm = MapViewOrderVm(
        context: context,
        update: setState,
        driveToken: widget.driveToken,
        oneTimeDriveModel: widget.model);
    loadMarkersMap();
  }

  Future<void> loadMarkersMap() async {
    var locationInfo = await LocationService.getLocationInfo(widget.myLocation);
    driverAddress =
        '${locationInfo?.address.addressComponents[1].shortName}, ${locationInfo?.address.addressComponents[0].shortName}';
    final iconMe = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "packages/nanny_components/assets/images/map/driver_location.png");
    markers.removeWhere((e) => e.markerId.value == 'me');
    setState(() {
      markers.add(Marker(
          markerId: const MarkerId('me'),
          position: widget.myLocation,
          icon: iconMe));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      GoogleMap(
          markers: NannyMapGlobals.markers.value,
          polylines: NannyMapGlobals.routes.value,
          onMapCreated: vm.initController,
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: widget.myLocation, zoom: 18)),
      Positioned(
          top: 52,
          left: 80,
          right: 80,
          child: driverAddress.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text('Ваш адрес ',
                                    style: NannyTextStyles.defaultTextStyle
                                        .copyWith(
                                            fontSize: 16,
                                            color: Colors.grey[600]))),
                            Icon(Icons.keyboard_arrow_right,
                                color: Colors.grey[600], size: 24)
                          ]),
                      const SizedBox(height: 4),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 10,
                                              color: Colors.black38)
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Text(driverAddress, maxLines: null)))
                          ])
                    ])
              : const SizedBox()),
      DraggableScrollableSheet(
          controller: sheetController,
          shouldCloseOnMinExtent: false,
          initialChildSize: _sheetPosition,
          minChildSize: 0.12,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
                color: Colors.transparent,
                child: Container(
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(blurRadius: 10, color: Colors.black38)
                        ],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24))),
                    child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onVerticalDragUpdate: (details) {
                                    setState(() {
                                      _sheetPosition -= details.delta.dy / 700;
                                      if (_sheetPosition < 0.12) {
                                        _sheetPosition = 0.12;
                                      }
                                      if (_sheetPosition > 0.5) {
                                        _sheetPosition = 0.5;
                                      }
                                    });
                                  },
                                  child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.only(top: 8),
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 4,
                                                width: 44,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.grey))
                                          ]))),
                              anyDriveWidget()
                            ]))));
          })
    ]));
  }

  Widget anyDriveWidget() {
    switch (vm.currentState) {
      case StatusValue.onPlace:
        return arriveWidget();
      case StatusValue.onWay:
        var distance = vm.currentDistance.isNaN
            ? 0.0
            : vm.currentDistance > 0
            ? vm.currentDistance
            : 0.0;

        return Column(children: [
          Text('Осталось ехать ${vm.timeToArriveMinutes} мин',
              style: NannyTextStyles.textTheme.bodyLarge),
          Text(vm.oneTimeDriveModel.addresses.first.to),
          const SizedBox(height: 32),
          seekDrive(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0 км',
                        style: NannyTextStyles.defaultTextStyle
                            .copyWith(color: Colors.grey[400])),
                    Text('${((vm.distanceToEnd / 2) / 1000).toStringAsFixed(1)} км',
                        style: NannyTextStyles.defaultTextStyle
                            .copyWith(color: Colors.grey[400])),
                    Text('${((vm.distanceToEnd) / 1000).toStringAsFixed(1)} км',
                        style: NannyTextStyles.defaultTextStyle
                            .copyWith(color: Colors.grey[400]))
                  ]))
        ]);
      case StatusValue.driveStarted:
        return driveStarted();
      case StatusValue.arrived:
        return arrivedToFinish();
      case StatusValue.awaiting:
        return awaitWidget();
      default:
        return Column(children: driveStartWidgets());
    }
  }

  Widget driveStarted() {
    return Column(children: [
      Text('Осталось ехать ${vm.timeToArriveMinutes} мин',
          style: NannyTextStyles.textTheme.bodyLarge),
      Text(vm.oneTimeDriveModel.addresses.first.to),
      const SizedBox(height: 20),
      ElevatedButton(
          onPressed: () {
            vm.onStatusChange(StatusValue.arrived);
          },
          child: const Text('Прибыл на конечную')),
      const SizedBox(height: 32),
      seekDrive()
    ]);
  }

  Widget seekDrive() {
    var distance = vm.currentDistance.isNaN
        ? 0.0
        : vm.currentDistance > 0
            ? vm.currentDistance
            : 0.0;

    return Theme(
        data: Theme.of(context).copyWith(
            sliderTheme: const SliderThemeData(
                thumbColor: NannyTheme.primary,
                activeTrackColor: NannyTheme.primary)),
        child: Slider(value: distance.toDouble(), onChanged: null));
  }

  Widget arrivedToFinish() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(children: [
          Row(children: [
            Image.asset(
                'packages/nanny_components/assets/images/map/map_marker_user.png',
                height: 24,
                width: 24),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(vm.oneTimeDriveModel.addresses.first.from,
                    maxLines: 2))
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Image.asset(
                'packages/nanny_components/assets/images/map/map_marker_loc.png',
                height: 24,
                width: 24),
            const SizedBox(width: 8),
            Expanded(
                child:
                    Text(vm.oneTimeDriveModel.addresses.first.to, maxLines: 2))
          ]),
          const SizedBox(width: 24),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          vm.onStatusChange(StatusValue.complete);
                        },
                        child: const Text('Завершить поездку')))
              ]))
        ]));
  }

  Widget arriveWidget() {
    return Column(children: [
      Text('Вы на месте', style: NannyTextStyles.textTheme.bodyLarge),
      Row(children: [
        Expanded(
            child: Column(children: [
          SizedBox(
              height: 60,
              width: 60,
              child: ProfileImage(
                  url: widget.model.avatar,
                  radius: 100,
                  padding: EdgeInsets.zero)),
          const SizedBox(height: 6),
          Text(widget.model.username,
              style: NannyTextStyles.defaultTextStyle
                  .copyWith(color: Colors.black54, fontSize: 13))
        ])),
        Expanded(
            child: CircularButton(
                sized: false,
                callback: () {},
                label: 'Связаться',
                child: SvgPicture.asset(
                    'packages/nanny_components/assets/images/call.svg'))),
        Expanded(
            child: CircularButton(
                sized: false,
                callback: Navigator.of(context).pop,
                label: 'Чат',
                child: SvgPicture.asset(
                    'packages/nanny_components/assets/images/chat.svg')))
      ]),
      const SizedBox(height: 24),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      vm.onStatusChange(StatusValue.awaiting);
                    },
                    child: const Text('Включить режим ожидания')))
          ]))
    ]);
  }

  Widget timeToArrive() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Осталось ехать', style: NannyTextStyles.textTheme.bodyLarge),
            Text('${vm.timeToArrive} миг',
                style: NannyTextStyles.textTheme.bodyLarge)
          ])),
      const SizedBox(height: 16),
      const SizedBox(height: 24),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      vm.onStatusChange(StatusValue.driveStarted);
                    },
                    child: Text('Начать поездку')))
          ]))
    ]);
  }

  Widget awaitWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Ожидание', style: NannyTextStyles.textTheme.bodyLarge),
            Text('${vm.getMinutes}:${vm.getSeconds}',
                style: NannyTextStyles.textTheme.bodyLarge)
          ])),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(
            child: Column(children: [
          SizedBox(
              height: 60,
              width: 60,
              child: ProfileImage(
                  url: widget.model.avatar,
                  radius: 100,
                  padding: EdgeInsets.zero)),
          const SizedBox(height: 6),
          Text(widget.model.username,
              style: NannyTextStyles.defaultTextStyle
                  .copyWith(color: Colors.black54, fontSize: 13))
        ])),
        Expanded(
            child: CircularButton(
                sized: false,
                callback: () {},
                label: 'Связаться',
                child: SvgPicture.asset(
                    'packages/nanny_components/assets/images/call.svg'))),
        Expanded(
            child: CircularButton(
                sized: false,
                callback: Navigator.of(context).pop,
                label: 'Чат',
                child: SvgPicture.asset(
                    'packages/nanny_components/assets/images/chat.svg')))
      ]),
      const SizedBox(height: 24),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      vm.onStatusChange(StatusValue.driveStarted);
                    },
                    child: Text('Начать поездку')))
          ]))
    ]);
  }

  List<Widget> driveFinishWidget() {
    return [
      ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.model.addresses.length,
          itemBuilder: (context, index) {
            var item = widget.model.addresses[index];
            return Column(
              children: [
                Row(children: [
                  Image.asset(
                      'packages/nanny_components/assets/images/map/map_marker_loc.png',
                      height: 24,
                      width: 24),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(item.from,
                          maxLines: null,
                          style: NannyTextStyles.defaultTextStyle
                              .copyWith(fontSize: 18)))
                ]),
                Row(children: [
                  Image.asset(
                      'packages/nanny_components/assets/images/map/map_marker_user.png',
                      height: 24,
                      width: 24),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(item.to,
                          maxLines: null,
                          style: NannyTextStyles.defaultTextStyle
                              .copyWith(fontSize: 18)))
                ]),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
                width: double.infinity,
                height: 24,
                child: Center(child: Divider(color: Colors.grey[300]!)));
          }),
      const SizedBox(height: 24),
      actionsWidget(),
      const SizedBox(height: 20),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: vm.onRideStart,
                    child: const Text('Начать поездку')))
          ])),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            Expanded(
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
                        onPressed: () {
                          vm.onStatusChange(StatusValue.canceledByDriver);
                          Navigator.of(context).pop();
                        },
                        child: Text('Отклонить',
                            style: NannyTextStyles.defaultTextStyle
                                .copyWith(color: Colors.black)))))
          ]))
    ];
  }

  List<Widget> driveStartWidgets() {
    return [
      ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.model.addresses.length,
          itemBuilder: (context, index) {
            var item = widget.model.addresses[index];
            return Row(children: [
              Image.asset(
                  index == 0
                      ? 'packages/nanny_components/assets/images/map/map_marker_user.png'
                      : 'packages/nanny_components/assets/images/map/map_marker_loc.png',
                  height: 24,
                  width: 24),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(index == 0 ? item.from : item.to,
                      maxLines: null,
                      style: NannyTextStyles.defaultTextStyle
                          .copyWith(fontSize: 18)))
            ]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
                width: double.infinity,
                height: 24,
                child: Center(child: Divider(color: Colors.grey[300]!)));
          }),
      const SizedBox(height: 24),
      actionsWidget(),
      const SizedBox(height: 20),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: vm.onRideStart,
                    child: const Text('Начать поездку')))
          ])),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            Expanded(
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
                        onPressed: () {
                          vm.onStatusChange(StatusValue.canceledByDriver);
                          Navigator.of(context).pop();
                        },
                        child: Text('Отклонить',
                            style: NannyTextStyles.defaultTextStyle
                                .copyWith(color: Colors.black)))))
          ]))
    ];
  }

  Widget actionsWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(children: [
            SizedBox(
                height: 51,
                width: 51,
                child: ProfileImage(
                    url: widget.model.avatar,
                    radius: 100,
                    padding: EdgeInsets.zero)),
            const SizedBox(height: 6),
            Text(widget.model.username,
                style: NannyTextStyles.defaultTextStyle
                    .copyWith(color: Colors.black54, fontSize: 13))
          ]),
          OrderActionButton(
              callback: () {},
              title: 'Связаться',
              asset: 'packages/nanny_components/assets/order/call.png'),
          OrderActionButton(
              callback: () {},
              title: 'Чат',
              asset: 'packages/nanny_components/assets/order/message.png'),
          OrderActionButton(
              callback: () {},
              title: 'Детали',
              asset: 'packages/nanny_components/assets/order/hamburger.png')
        ]));
  }
}
