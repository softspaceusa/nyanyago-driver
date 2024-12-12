import 'package:nanny_components/view_model_base.dart';
import 'package:nanny_core/api/api_models/get_users_request.dart';
import 'package:nanny_core/api/nanny_orders_api.dart';
import 'package:nanny_core/models/from_api/franchise/order_model.dart';
import 'package:nanny_core/nanny_core.dart';

class DriverOrdersVM extends ViewModelBase {
  DriverOrdersVM({required super.context, required super.update}) {
    delayer = SearchDelayer<List<OrderModel>>(
      delay: const Duration(seconds: 1),
      initRequest: NannyOrdersApi.getFranchiseDriverOrders(),
      update: () => update(() {}),
    );
  }

  String status = "";

  GetUsersRequest query = GetUsersRequest(statuses: [""]);
  late final SearchDelayer<List<OrderModel>> delayer;

  void resendRequestWithDelay() => delayer.wait(
        onCompleteRequest: NannyOrdersApi.getFranchiseDriverOrders(),
      );

  void resendRequest() =>
      delayer.updateRequest(NannyOrdersApi.getFranchiseDriverOrders());

  void changeFilter(String value) {
    status = value;
    query = query.copyWith(
      statuses: [value],
    );
    resendRequest();
  }
}
