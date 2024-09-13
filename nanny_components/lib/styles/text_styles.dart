import 'package:flutter/material.dart';

class NannyTextStyles {
  static final TextTheme textTheme = TextTheme(
    bodyLarge: defaultTextStyle.copyWith(
      fontSize: 24
    ),
    bodyMedium: defaultTextStyle.copyWith(
      fontSize: 16
    ),
    bodySmall: defaultTextStyle.copyWith(
      fontSize: 12
    ),

    displayLarge: defaultTextStyle.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700
    ),
    displayMedium: defaultTextStyle.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700
    ),
    displaySmall: defaultTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w700
    ),

    headlineLarge: titleStyle.copyWith(
      fontSize: 40,
      fontWeight: FontWeight.w700
    ),
    headlineMedium: titleStyle.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700
    ),
    headlineSmall: titleStyle.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700
    ),

    labelLarge: defaultTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w700
    ),
    labelMedium: defaultTextStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w700
    ),
    labelSmall: defaultTextStyle.copyWith(
      fontSize: 8,
      fontWeight: FontWeight.w700
    ),

    titleLarge: titleStyle.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700
    ),
    titleMedium: titleStyle.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700
    ),
    titleSmall: titleStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w700
    ),
  );

  static const TextStyle defaultTextStyle = TextStyle(
    fontFamily: "Nunito",
  );

  static const TextStyle titleStyle = TextStyle(
    fontFamily: "Fregat",
  );
}