import 'package:flutter/material.dart';

class LoadScreen {
  static BuildContext? _lastContext;
  static void showLoad(BuildContext context, bool show) {
    if(show) {
      if(_lastContext != null && _lastContext!.mounted) Navigator.pop(_lastContext!);
      
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (dContext) {
          _lastContext = dContext;

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      );
      return;
    }

    if(_lastContext != null && _lastContext!.mounted) {
      Navigator.pop(_lastContext!);
      _lastContext = null;
    }
  }
}