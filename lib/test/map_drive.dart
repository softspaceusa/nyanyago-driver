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
  final GlobalKey<NavigatorState> navKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    init = initView();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureLoader(
          future: init,
          completeView: (context, data) => MapViewer(
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: data,
              ),
            ), 
            panel: const AddressChooseView()
          ),
          errorView: (context, error) => ErrorView(errorText: error.toString()),
        ),
      )
    );
  }

  late Future<LatLng> init;
  Future<LatLng> initView() async {
    var location = await LocationService.location.getLocation();
    return NannyMapUtils.locData2LatLng(location);
  }

  bool inited = false;

  Route? onRouteGen(RouteSettings settings) {
    if(!inited) {
      inited = true;
      return MaterialPageRoute(builder: (context) => const AddressChooseView());
    }
    return null;
  }
}