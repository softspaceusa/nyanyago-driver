import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/search_query_request.dart';
import 'package:nanny_core/models/from_api/drive_and_map/driver_schedule_response.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
import 'package:nanny_core/nanny_core.dart';

class OffersVM extends ViewModelBase {
  OffersVM({
    required super.context, 
    required super.update,
  });

  OfferType selectedOfferType = OfferType.route;

  List<DriverScheduleResponse> offers = [];
  List<OtherParametr> params = [];

  @override
  Future<bool> loadPage() async {
    var paramRes = await NannyStaticDataApi.getOtherParams();
    if(!paramRes.success) return false;

    params = paramRes.response!;

    var offerRes = await NannyDriverApi.getScheduleRequests(SearchQueryRequest());
    if(!offerRes.success) return false;

    offers = offerRes.response!;

    return true;
  }

  void changeOfferType(OfferType type) => update(() {
    selectedOfferType = type;
    reloadPage();
  });
}