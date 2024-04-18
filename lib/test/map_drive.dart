import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_components/widgets/map_viewer.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_driver/test/address_choose.dart';

class MapDriveView extends StatefulWidget {
  const MapDriveView({super.key});

  @override
  State<MapDriveView> createState() => _MapDriveViewState();
}

class _MapDriveViewState extends State<MapDriveView> {
  @override
  void initState() {
    super.initState();
    init = initView();

    NannyMapGlobals.routes.addListener( () {
      try {
        setState(() {});
      } on Exception catch(_) {}
      // Logger().i("Updated map!");
    });
    NannyMapGlobals.markers.addListener(() {
      try {
        setState(() {});
      } on Exception catch(_) {}
      // Logger().i("Updated map markers!");
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AdaptBuilder(
        builder: (context, size) {
          return Scaffold(
            body: FutureLoader(
              future: init,
              completeView: (context, data) => MapViewer(
                onPanelBuild: (sc) => scrController = sc,
                body: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: data,
                    zoom: 15
                  ),

                  onTap: (pos) => NannyMapGlobals.mapTapController.add(pos),
                  
                  polylines: NannyMapGlobals.routes.value,
                  markers: NannyMapGlobals.markers.value,
                ), 
                
                panel: Navigator(
                  initialRoute: '/',
                  onGenerateRoute: onRouteGen,
                ),
              ),
              errorView: (context, error) => ErrorView(errorText: error.toString()),
            ),
          );
        }
      )
    );
  }

  ScrollController scrController = ScrollController();

  late Future<LatLng> init;
  Future<LatLng> initView() async {
    var location = await LocationService.location.getLocation();
    return NannyMapUtils.locData2LatLng(location);
  }

  bool inited = false;
  Route? onRouteGen(RouteSettings settings) {
    if(settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) => AddressChooseView(baseContext: context, scrController: scrController)
      );
    }
    return null;
  }
}