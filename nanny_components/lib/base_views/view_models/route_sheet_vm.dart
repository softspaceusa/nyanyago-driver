import 'package:flutter/material.dart';
import 'package:nanny_components/models/address_view_data.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/google_map_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/address_data.dart';
import 'package:nanny_core/models/from_api/drive_and_map/geocoding_data.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:time_range_picker/time_range_picker.dart';


class RouteSheetVM extends ViewModelBase {
  final NannyWeekday weekday;
  
  RouteSheetVM({
    required super.context, 
    required super.update,
    required this.weekday
  });

  String roadName = "";
  GeocodeResult? addressFrom;
  List<AddressViewData> addresses = [];
  GeocodeResult? addressTo;
  TimeRange? timeRange;
  // TimeOfDay? start;
  // TimeOfDay? end;

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  // TextEditingController timeFromController = TextEditingController();
  // TextEditingController timeToController = TextEditingController();

  void chooseAddress({required bool from}) async {
    var address = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        onSearch: (query) => GoogleMapApi.geocode(address: query), 
        onResponse: (response) => response.response!.geocodeResults,
        tileBuilder: (data, close) => ListTile(
          title: Text(data.formattedAddress),
          onTap: close,
        ),
      ),
    );

    if(address == null) return;
    
    if(from) {
      addressFrom = address;
      fromController.text = NannyMapUtils.simplifyAddress(address.formattedAddress);
    }
    else {
      addressTo = address;
      toController.text = NannyMapUtils.simplifyAddress(address.formattedAddress);
    }

    update(() {});
  }

  void chooseAddtionAddress(AddressViewData data) async {
    var address = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        onSearch: (query) => GoogleMapApi.geocode(address: query), 
        onResponse: (response) => response.response!.geocodeResults,
        tileBuilder: (data, close) => ListTile(
          title: Text(data.formattedAddress),
          onTap: close,
        ),
      ),
    );

    if(address == null) return;

    data.address = address;
    data.controller.text = NannyMapUtils.simplifyAddress(address.formattedAddress);

    update(() {});
  }

  void removeAddress(AddressViewData data) {
    addresses.remove(data);

    update(() {});
  }

  void addAddress() {
    addresses.add(AddressViewData());

    update(() {});
  }

  void chooseTime() async {
    // var time = await showTimePicker(
    //   context: context, 
    //   cancelText: "Отмена",
    //   confirmText: "Подтвердить",
    //   hourLabelText: "Часы",
    //   minuteLabelText: "Минуты",
    //   errorInvalidText: "Ошибка",
    //   helpText: "Выберите время",

    //   initialTime: TimeOfDay.now(),
    // );

    TimeRange? time = await showTimeRangePicker(
      context: context,
      disabledTime: TimeRange(
        startTime: const TimeOfDay(hour: 20, minute: 0), 
        endTime: const TimeOfDay(hour: 5, minute: 0)
      ),
      minDuration: const Duration(hours: 1),
      interval: const Duration(minutes: 15),

      barrierDismissible: false,
      snap: true,
      ticks: 24,
      labels: [
        ClockLabel(angle: 0, text: "18"),
        ClockLabel(angle: 0.525, text: "20"),
        ClockLabel(angle: 1.05, text: "22"),
        ClockLabel(angle: 1.575, text: "0"),
        ClockLabel(angle: 2.1, text: "2"),
        ClockLabel(angle: 2.625, text: "4"),
        ClockLabel(angle: 3.15, text: "6"),
        ClockLabel(angle: 3.675, text: "8"),
        ClockLabel(angle: 4.2, text: "10"),
        ClockLabel(angle: 4.725 , text: "12"),
        ClockLabel(angle: 5.25, text: "14"),
        ClockLabel(angle: 5.775, text: "16"),
      ],
      fromText: "От",
      toText: "До",
      strokeColor: NannyTheme.primary,
      handlerColor: NannyTheme.primary,
    );

    if(time == null) return;
    if(!context.mounted) return;

    timeRange = time;

    // if(isFrom) { 
    //   start = time;
    //   timeFromController.text = time.format(context); 
    // }
    // else { 
    //   end = time;
    //   timeToController.text = time.format(context); 
    // }
    update(() {});
  }

  void cancel() => Navigator.pop(context);
  void confirm() async {
    if(roadName.isEmpty ||
       fromController.text.isEmpty ||
       toController.text.isEmpty ||
       timeRange == null ||
       addresses.any((e) => e.address == null)
    ) {
      NannyDialogs.showMessageBox(context, "Ошибка", "Заполните форму!");
      return;
    }

    // LoadScreen.showLoad(context, true);

    // var balance = NannyUsersApi.getMoney();
    // bool success = await DioRequest.handleRequest(
    //   context, 
    //   balance
    // );

    // if(!success) return;
    // var result = await balance;
    // if(!context.mounted) return;

    // if(result.response!.balance < 1000) {
    //   LoadScreen.showLoad(context, false);
    //   await NannyDialogs.showMessageBox(context, "Ошибка!", "На счете недостаточно средств!");
    //   // ignore: use_build_context_synchronously
    //   Navigator.pop(context, null);
    //   return;
    // }

    List<DriveAddress> driveAddresses = [];

    if(addresses.isEmpty) {
      driveAddresses.add(
        DriveAddress(
          fromAddress: AddressData(
            address: NannyMapUtils.simplifyAddress(addressFrom!.formattedAddress), 
            location: addressFrom!.geometry!.location!
          ), 
          toAddress: AddressData(
            address: NannyMapUtils.simplifyAddress(addressTo!.formattedAddress), 
            location: addressTo!.geometry!.location!
          ),
        )
      );
    }
    else {
      driveAddresses.add(
        DriveAddress(
          fromAddress: AddressData(
            address: NannyMapUtils.simplifyAddress(addressFrom!.formattedAddress),
            location: addressFrom!.geometry!.location!
          ), 
          toAddress: AddressData(
            address: NannyMapUtils.simplifyAddress(addresses.first.address!.formattedAddress),
            location: addresses.first.address!.geometry!.location!
          )
        )
      );

      for(int i = 0; i < addresses.length - 1; i += 2) {
        driveAddresses.add(
          DriveAddress(
            fromAddress: AddressData(
              address: NannyMapUtils.simplifyAddress(addresses[i].address!.formattedAddress), 
              location: addresses[i].address!.geometry!.location!
            ),
            toAddress: AddressData(
              address: NannyMapUtils.simplifyAddress(addresses[i + 1].address!.formattedAddress), 
              location: addresses[i + 1].address!.geometry!.location!
            )
          )
        );
      }

      driveAddresses.add(
        DriveAddress(
          fromAddress: AddressData(
            address: NannyMapUtils.simplifyAddress(addresses.last.address!.formattedAddress),
            location: addresses.last.address!.geometry!.location!
          ),
          toAddress: AddressData(
            address: NannyMapUtils.simplifyAddress(addressTo!.formattedAddress),
            location: addressTo!.geometry!.location!
          ), 
        )
      );
    }

    Navigator.pop(
        context, 
        Road(
          weekDay: weekday, 
          startTime: timeRange!.startTime, 
          endTime: timeRange!.endTime, 
          addresses: driveAddresses, 
          title: roadName, 
          typeDrive: [
            DriveType.oneWay,
            if(addresses.isNotEmpty) DriveType.withInterPoint
          ]
        )
      );
  }
}

extension TimeRangeAdditions on TimeRange {
  String toLocalTimeString() {
    String from = startTime.formatTime();
    String to = endTime.formatTime();

    return "$from - $to";
  }
}