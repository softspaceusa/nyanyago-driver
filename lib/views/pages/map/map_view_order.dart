import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/order_action_button.dart';
import 'package:nanny_components/styles/text_styles.dart';
import 'package:nanny_components/widgets/one_time_drive_widget.dart';
import 'package:nanny_core/map_services/location_service.dart';
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
        orderId: widget.orderId);
    loadMarkersMap();
  }

  Future<void> loadMarkersMap() async {
    var locationInfo = await LocationService.getLocationInfo(widget.myLocation);
    driverAddress =
        '${locationInfo?.address.addressComponents[1].shortName}, ${locationInfo?.address.addressComponents[0].shortName}';
    final iconMe = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "packages/nanny_components/assets/images/map/driver_location.png");
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
          markers: markers,
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
                              ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
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
                                          child: Text(
                                              index == 0 ? item.from : item.to,
                                              maxLines: null,
                                              style: NannyTextStyles
                                                  .defaultTextStyle
                                                  .copyWith(fontSize: 18)))
                                    ]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                        width: double.infinity,
                                        height: 24,
                                        child: Center(
                                            child: Divider(
                                                color: Colors.grey[300]!)));
                                  }),
                              // Padding(
                              //     padding: const EdgeInsets.only(
                              //         top: 24, bottom: 24, left: 20, right: 0),
                              //     child: Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Text('Стоимость',
                              //               style: NannyTextStyles
                              //                   .defaultTextStyle
                              //                   .copyWith(
                              //                       fontSize: 18,
                              //                       fontWeight: FontWeight.w700)),
                              //           Row(children: [
                              //             Text('~${widget.model.price} ₽',
                              //                 textAlign: TextAlign.center,
                              //                 style: NannyTextStyles
                              //                     .defaultTextStyle
                              //                     .copyWith(
                              //                         fontSize: 24,
                              //                         fontWeight:
                              //                             FontWeight.w700))
                              //           ])
                              //         ])),
                              const SizedBox(height: 24),
                              actionsWidget(),
                              const SizedBox(height: 20),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  child: Row(children: [
                                    Expanded(
                                        child: ElevatedButton(
                                            onPressed: vm.onRideStart,
                                            child:
                                                const Text('Начать поездку')))
                                  ])),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(children: [
                                    Expanded(
                                        child: Theme(
                                            data: Theme.of(context).copyWith(
                                                elevatedButtonTheme:
                                                    ElevatedButtonThemeData(
                                                        style: Theme.of(context)
                                                            .elevatedButtonTheme
                                                            .style
                                                            ?.copyWith(
                                                                backgroundColor:
                                                                    const WidgetStatePropertyAll(Colors
                                                                        .white)))),
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                child: Text('Отклонить',
                                                    style: NannyTextStyles
                                                        .defaultTextStyle
                                                        .copyWith(color: Colors.black)))))
                                  ]))
                            ]))));
          })
    ]));
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
