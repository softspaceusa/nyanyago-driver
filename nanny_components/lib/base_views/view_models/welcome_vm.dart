import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';

class WelcomeVM extends ViewModelBase {
  WelcomeVM({
    required super.context,
    required super.update,
    required this.regScreen,
    required this.loginPaths,
  }) {
    requestPermissions();
    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Версия сборки: 0.2.0"), // TODO: Track version
      ));
    });
  }

  final Widget regScreen;
  final List<LoginPath> loginPaths;

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(
          imgPath: "packages/nanny_components/assets/images/Saly-10.png",
          paths: loginPaths,
        ),
      ),
    );
  }

  void navigateToReg() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneConfirmView(
            nextScreen: regScreen,
            title: "Подтверждение номера",
            text:
                "Введите номер телефона и мы отправим вам код с письмом через SMS",
            isReg: true,
            loginPaths: loginPaths),
      ),
    );
  }

  Future<void> requestPermissions() async {
    List<String> deniedPerms = [];

    // Разрешение на геолокацию
    if (await Permission.locationAlways.isDenied) {
      if (context.mounted) {
        await NannyDialogs.showMessageBox(
          context,
          "Внимание!",
          "Автоняне нужен постоянный доступ к вашей геолокации!\nМы перенаправим вас в настройки геолокации...",
        );
      }
      await Permission.locationAlways.request();
    }

    // Разрешение на контакты
    if (await Permission.contacts.isDenied) {
      if (context.mounted) {
        await NannyDialogs.showMessageBox(
          context,
          "Внимание!",
          "Автоняне нужен доступ к вашим контактам для корректной работы!",
        );
      }
      await Permission.contacts.request();
    }

    // Разрешения на уведомления
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        sound: true,
        provisional: true,
      );
    } else {
      await Permission.notification.request();
    }

    if (await Permission.notification.isDenied) {
      await NannyDialogs.showMessageBox(
        context,
        "Внимание!",
        "Автоняне нужны разрешения на показ уведомлений, чтобы корректно работать!"
            "\nМы перенаправим вас в настройки, чтобы вы дали разрешение...",
      );
      await Permission.notification.request();
    }

    // Если какие-то разрешения остались отклонёнными, отправляем пользователя в настройки
    if (deniedPerms.isNotEmpty) {
      if (!context.mounted) {
        openAppSettings();
        return;
      }

      await NannyDialogs.showMessageBox(
        context,
        "Внимание!",
        "Автоняне нужны разрешения на ${deniedPerms.join(', ')}, чтобы корректно работать!"
            "\nМы перенаправим вас в настройки, чтобы вы дали разрешение...",
      );
      openAppSettings();
    }
  }
}
