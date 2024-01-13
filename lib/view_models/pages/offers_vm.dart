import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class OffersVM extends ViewModelBase {
  OffersVM({
    required super.context, 
    required super.update,
  });

  OfferType selectedOfferType = OfferType.route;

  void changeOfferType(OfferType type) => update(() => selectedOfferType = type);
}