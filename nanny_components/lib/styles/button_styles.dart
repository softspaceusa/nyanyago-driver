import 'package:flutter/material.dart';
import 'package:nanny_components/styles/nanny_theme.dart';

class NannyButtonStyles {
  static final ElevatedButtonThemeData elevatedBtnTheme =
      ElevatedButtonThemeData(style: defaultButtonStyle);
  static final TextButtonThemeData textBtnTheme =
      TextButtonThemeData(style: defaultButtonStyleWithNoSize);

  static final ButtonThemeData defaultButtonTheme = ButtonThemeData(
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ));

  static final ButtonStyle defaultButtonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(200, 50),
      maximumSize: const Size(double.infinity, 100),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ));

  static final ButtonStyle defaultButtonStyleWithNoSize =
      ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));

  static const ButtonStyle whiteButton = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(NannyTheme.secondary),
      foregroundColor: WidgetStatePropertyAll(NannyTheme.onSecondary),
      overlayColor: WidgetStatePropertyAll(NannyTheme.lightPink));

  static const ButtonStyle lightGreen = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(NannyTheme.lightGreen),
      foregroundColor: WidgetStatePropertyAll(NannyTheme.onSecondary),
      overlayColor: WidgetStatePropertyAll(NannyTheme.green));

  static const ButtonStyle green = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(NannyTheme.green),
      foregroundColor: WidgetStatePropertyAll(NannyTheme.onSecondary),
      overlayColor: WidgetStatePropertyAll(NannyTheme.lightGreen));

  static const ButtonStyle transparent = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(NannyTheme.onSecondary),
      overlayColor: WidgetStatePropertyAll(NannyTheme.grey),
      elevation: WidgetStatePropertyAll(0));
}
