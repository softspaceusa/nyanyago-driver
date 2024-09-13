import 'package:flutter/material.dart';
import 'package:nanny_components/base_views/views/route_sheet.dart';
import 'package:nanny_core/models/from_api/drive_and_map/schedule.dart';
import 'package:nanny_core/nanny_core.dart';

class NannyDialogs {
  static Future<void> showMessageBox(BuildContext context, String title, String msg) async {
    await showDialog(context: context, builder: (dContext) => SimpleDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.titleSmall,
      elevation: 10,
      
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(msg, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dContext), 
                  child: const Text("Ок")
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  static Future<bool> showModalDialog({
    required BuildContext context, 
    required Widget child, 
    String? title, 
    List<Widget>? actions,
    bool hasDefaultBtn = true,
  }) async {
    actions ??= [];
    
    if(hasDefaultBtn) {
      actions.add(ElevatedButton(
        onPressed: () => Navigator.pop(context, true), 
        child: const Text("Ок")
      ));
    }
    
    return await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (dContext) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(title != null) Flexible(child: Text(title, maxLines: 2)),
              if(title != null) const SizedBox(width: 10),
              IconButton(
                onPressed: () => Navigator.pop(dContext, false),
                icon: const Icon(Icons.close),
                iconSize: 30,
                splashRadius: 30,
              ),
            ],
          ),
          titleTextStyle: Theme.of(dContext).textTheme.titleSmall,
          children: [
            Column(
              children: [
                child,
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: actions!,
                ),
              ],
            ),
          ],
        );
      }
    ) ?? false;
  }

  static Future<bool> confirmAction(BuildContext context, String promt) async {
    return await showModalDialog(
      context: context, 
      title: "Подтверждение действия",
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(promt, textAlign: TextAlign.center,),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Отмена")
        ),
      ]
    ) ;
  }

  static Future<Road?> showRouteCreateSheet(BuildContext context, NannyWeekday weekday) async {
    return await showModalBottomSheet(
      context: context, 
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: RouteSheetView(weekday: weekday),
      ),
    );
  }
}