import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/nanny_franchise_api.dart';
import 'package:nanny_core/models/from_api/my_referals_data.dart';
import 'package:nanny_core/nanny_core.dart';

class MyReferalsVM extends ViewModelBase {
  MyReferalsVM({
    required super.context,
    required super.update,
  }) {
    request = NannyFranchiseApi.getMyReferals();
  }

  late Future<ApiResponse<MyReferalData>> request;

  String formatCurrency(double balance) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    String formatted =
        formatter.format(balance).replaceAll(',', ' ').replaceAll('.', ', ');
    return "$formatted Р";
  }
}
