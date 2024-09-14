import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_core/nanny_local_auth.dart';
import 'package:nanny_driver/franchise/views/franchise_home.dart';
import 'package:nanny_driver/franchise/views/partner/partner_home.dart';
import 'package:nanny_driver/views/home.dart';
import 'package:nanny_driver/views/reg.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.grey[50]!));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Intl.defaultLocale = "ru_RU";
  initializeDateFormatting(Intl.defaultLocale);

  DioRequest.init();
  DioRequest.initDebugLogs();

  LocationService.initBackgroundLocation();
  LocationService.initLocInfo();

  NannyConsts.setLoginPaths([
    LoginPath(userType: UserType.driver, path: const HomeView()),
    LoginPath(
        userType: UserType.franchiseAdmin, path: const FranchiseHomeView()),
    LoginPath(userType: UserType.manager, path: const FranchiseHomeView()),
    LoginPath(userType: UserType.operator, path: const FranchiseHomeView()),
    LoginPath(userType: UserType.partner, path: const PartnerHomeView()),
    LoginPath(
        userType: UserType.admin,
        path: const AdminHomeView(regView: RegView())),
  ]);

  await NannyConsts.initMarkerIcons();

  NannyLocalAuth.init();

  await NannyStorage.init(isClient: false);
  FirebaseMessagingHandler.init();

  Logger().d(
      "Storage data:\nLogin data - ${(await NannyStorage.getLoginData())?.toJson()}");

  runApp(MainApp(
      firstScreen: await NannyUser.autoLogin(
          paths: NannyConsts.availablePaths,
          defaultView: WelcomeView(
              regView: const RegView(),
              loginPaths: NannyConsts.availablePaths))));
}

class MainApp extends StatelessWidget {
  final Widget firstScreen;

  const MainApp({
    super.key,
    required this.firstScreen,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ru', ''),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorKey: NannyGlobals.navKey,
        theme: NannyTheme.appTheme,
        home: firstScreen
        // home: const TestView(),
        );
  }
}

// На случай, если Пятисотый забыл сертификаты обновить

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
