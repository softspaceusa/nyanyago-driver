import 'package:flutter/material.dart';
import 'package:nanny_components/modal_widget/details_widget.dart';
import 'package:nanny_core/models/from_api/drive_and_map/drive_tariff.dart';
import 'package:nanny_core/models/from_api/other_parametr.dart';
import 'package:nanny_core/nanny_globals.dart';

class BaseBottomSheet {
  static Future<bool> showDetails(
    List<String> addresses,
    List<OtherParametr> params,
    Set<int> selectedParams,
    int selectedDriverType,
    double amount,
    DriveTariff selectedTariff,
    Function(Map<String, dynamic>) onParamsChanged, {
    bool canEdit = false,
    int? duration,
  }) async {
    var result = await _showModalControlled(
        DetailsWidget(
            addresses: addresses,
            params: params,
            selectedParams: selectedParams,
            selectedDriverType: selectedDriverType,
            amount: amount,
            selectedTariff: selectedTariff,
            onParamsChanged: onParamsChanged,
            canEdit: canEdit,
            duration: duration),
        cancellable: true,
        padding: EdgeInsets.zero);
    if (result == true) {
      return true;
    }
    return false;
  }

  static BuildContext? getContext() =>
      NannyGlobals.navKey.currentState?.context;

  static Future<dynamic> _showModalControlled(Widget child,
      {BuildContext? currentContext,
      bool cancellable = false,
      EdgeInsets? padding}) async {
    final context = currentContext ?? getContext();
    if (context != null) {
      return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: cancellable,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                Container(
                    padding: padding ?? const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(247, 247, 247, 1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16))),
                    child: child)
              ],
            ),
          );
        },
      );
    }
  }
}
