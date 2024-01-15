import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/google_map_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/geocoding_data.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/test/in_drive.dart';

class AddressChooseVM extends ViewModelBase {
  AddressChooseVM({
    required super.context, 
    required super.update,
    required this.baseContext,
  });

  final BuildContext baseContext;

  GeocodeResult? addressA, addressB;
  TextEditingController aController = TextEditingController();
  TextEditingController bController = TextEditingController();
  Set<Polyline> routes = NannyMapGlobals.routes.value;

  void searchAddress(int i) async {
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

    if(i == 0) {
      addressA = result;
      aController.text = NannyMapUtils.simplifyAddress(result.formattedAddress);
    }
    else {
      addressB = result;
      bController.text = NannyMapUtils.simplifyAddress(result.formattedAddress);
    }
  }

  void setPolyline() async {
    if(addressA == null || addressB == null) return;
    var orig = addressA!.geometry!.location!;
    var dest = addressB!.geometry!.location!;

    var route = await RouteManager.calculateRoute(origin: orig, destination: dest);
    if(route == null) return;
    
    routes.clear();
    routes.add(
      route
    );
    NannyMapGlobals.routes.notifyListeners();

    Navigator.push(
      context, 
      MaterialPageRoute( builder: (context) => const InDriveView() )
    );
  }
}