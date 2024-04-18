import 'package:flutter/material.dart';
import 'package:nanny_components/models/address_view_data.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/google_map_api.dart';
import 'package:nanny_core/map_services/drive_manager.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/test/in_drive.dart';

class AddressChooseVM extends ViewModelBase {
  AddressChooseVM({
    required super.context, 
    required super.update,
    required this.baseContext,
  });

  final BuildContext baseContext;

  List<AddressViewData> addresses = [
    AddressViewData(),
    AddressViewData(),
  ];
  Set<Polyline> routes = NannyMapGlobals.routes.value;

  List<DriveTariff> _tariffs = [];
  List<DriveTariff> get tariffs => _tariffs;

  @override
  Future<bool> loadPage() async {
    var tariffRes = await NannyStaticDataApi.getTariffs();
    if(!tariffRes.success) return false;

    _tariffs = tariffRes.response!;
    
    return true;
  }

  void searchAddress(AddressViewData data) async {
    var result = await showSearch(
      context: baseContext, 
      delegate: NannySearchDelegate(
        onSearch: (query) => GoogleMapApi.geocode(address: query),
        onResponse: (response) => response.response!.geocodeResults,
        tileBuilder: (data, close) => ListTile(
          title: Text(data.formattedAddress),
          onTap: close,
        ),
      ),
    );

    if(result == null) return;

    data.address = result;
    data.controller.text = NannyMapUtils.simplifyAddress(result.formattedAddress);

    update(() {});
  }

  void addAddress() {
    addresses.add(AddressViewData());
    update(() {});
  }

  void removeAddress(AddressViewData data) {
    addresses.remove(data);
    update(() {});
  }

  void setPolyline() async {
    if(addresses.length < 2 || addresses.where((e) => e.address == null).isNotEmpty) return;

    var route = await RouteManager.calculateRoute(
      origin: addresses.first.address!.geometry!.location!, 
      destination: addresses.last.address!.geometry!.location!
    );
    if(route == null) return;
    
    routes.clear();
    routes.add(
      route
    );
    NannyMapGlobals.routes.notifyListeners();

    var manager = DriveManager(
      routes: [route], 
      addresses: [
        addresses.first.address!,
        addresses.last.address!
      ]
    );

    Navigator.push(
      context, 
      MaterialPageRoute( builder: (context) => InDriveView(driveManager: manager) )
    );
  }
}