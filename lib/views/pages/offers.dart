import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/models/from_api/drive_and_map/address_data.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/drive_and_map/driver_schedule_response.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/test/map_drive.dart';
import 'package:nanny_driver/view_models/pages/offers_vm.dart';
import 'package:nanny_components/base_views/views/schedule_checker.dart';

class OffersView extends StatefulWidget {
  final bool persistState;
  
  const OffersView({
    super.key,
    required this.persistState,
  });

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> with AutomaticKeepAliveClientMixin {
  late OffersVM vm;

  @override
  void initState() {
    super.initState();
    vm = OffersVM(context: context, update: setState);
  }

  @override
  Widget build(BuildContext context) {
    if(wantKeepAlive) super.build(context);
    
    return SafeArea(
      child: Scaffold(
        appBar: const NannyAppBar(
          hasBackButton: false,
          title: "Список предложений",
        ),
        body: Column(
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
            Expanded(
              child: FutureLoader(
                future: vm.loadRequest, 
                completeView: (context, data) {
                  // if(!data) {
                  //   return const ErrorView(errorText: "Не удалось загрузить даные!");
                  // }
                      
                  return ListView( // TODO: Доделать предложения!
                    shrinkWrap: true,
                    children: vm.selectedOfferType == OfferType.oneTime ?
                      vm.offers.map(
                        (e) => Card(
                          
                        )
                      ).toList()
                      : testSched.map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () => vm.navigateToView(ScheduleCheckerView(schedule: e)),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                              
                                    clientProfile(e),
                                    ListView(
                                      shrinkWrap: true,
                                      children: e.roads.map(
                                        (road) => Card(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(road.weekDay.fullName),
                                              Text("${road.startTime.formatTime()} - ${road.endTime.formatTime()}")
                                            ],
                                          ),
                                        )
                                      ).toList(),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: e.otherParametrs.map(
                                        (e) => CheckboxListTile(
                                          value: true,
                                          onChanged: null,
                                          title: Text(vm.params.firstWhere((param) => param.id == e.id!).title!),
                                        )
                                      ).toList(),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Общая стоимость: ${e.allSalary}")
                                    )
                                              
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ).toList(),
                  );
                }, 
                errorView: (context, error) => ErrorView(errorText: error.toString()),
              ),
            ),
            ElevatedButton(
              onPressed: () => vm.navigateToView(const MapDriveView()), 
              child: const Text("Тестовая поездка вручную"),
            ),
           
          ],
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

  Widget clientProfile(DriverScheduleResponse schedule) {
    return ListTile(
      leading: ProfileImage(
        url: schedule.user.photoPath, 
        radius: 30
      ),
      title: Text(schedule.user.name),
      subtitle: Text("Детей: ${schedule.childrenCount}"),
      // trailing: Card(
      //   color: NannyTheme.lightGreen,
      //   child: Text(schedule.),
      // ),
    );
  }

  List<DriverScheduleResponse> testSched = [
    DriverScheduleResponse(
      title: "title", 
      duration: 30, 
      childrenCount: 2, 
      weekdays: [NannyWeekday.monday], 
      tariff: DriveTariff(id: 0, title: "Tariff"), 
      otherParametrs: [OtherParametr(id: 1, title: "Переодеть")],
      roads: [Road(
        weekDay: NannyWeekday.monday, 
        startTime: TimeOfDay(hour: 12, minute: 10), 
        endTime: TimeOfDay(hour: 13, minute: 0), 
        addresses: [DriveAddress(
          fromAddress: AddressData(
            address: "address", 
            location: LatLng(0, 0)
          ), 
          toAddress: AddressData(
            address: "address", 
            location: LatLng(0, 0)
          ), 
        )], 
        title: "Road title", 
        typeDrive: [
          DriveType.oneWay
        ]
      ),
      Road(
        weekDay: NannyWeekday.monday, 
        startTime: TimeOfDay(hour: 12, minute: 10), 
        endTime: TimeOfDay(hour: 13, minute: 0), 
        addresses: [DriveAddress(
          fromAddress: AddressData(
            address: "address", 
            location: LatLng(0, 0)
          ), 
          toAddress: AddressData(
            address: "address", 
            location: LatLng(0, 0)
          ), 
        )], 
        title: "Road title", 
        typeDrive: [
          DriveType.oneWay
        ]
      )],
      user: ScheduleUser(
        idUser: 1, 
        name: "name", 
        photoPath: "photoPath"
      ), 
      allSalary: 150
    )
  ];
  
  @override
  bool get wantKeepAlive => widget.persistState;
}