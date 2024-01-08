import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/nanny_core.dart';
import 'package:nanny_core/nanny_local_auth.dart';
import 'package:nanny_driver/views/home.dart';
import 'package:nanny_driver/views/reg.dart';

import 'firebase_options.dart';
import 'test.dart';

void main() async { // TODO: home and reg screen views needed
  WidgetsFlutterBinding.ensureInitialized();
  
  LocationService.initBackgroundLocation();

  HttpOverrides.global = MyHttpOverrides();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: NannyTheme.primary
    )
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Intl.defaultLocale = "ru_RU";
  initializeDateFormatting(Intl.defaultLocale);
  
  DioRequest.init(useOldUrl: true);
  DioRequest.initDebugLogs();

  NannyConsts.setLoginPaths([
    LoginPath(userType: UserType.driver, path: const HomeView()),
    LoginPath(userType: UserType.admin, path: const AdminHomeView(regView: RegView()) ),
  ]);

  await NannyConsts.initMarkerIcons();

  NannyLocalAuth.init();

  await NannyStorage.init();
  FirebaseMessagingHandler.init();

  Logger().d("Storage data:\nLogin data - ${(await NannyStorage.getLoginData())?.toJson()}");
  
  runApp(
    MainApp(
      firstScreen: await NannyUser.autoLogin(
        paths: NannyConsts.availablePaths, 
        defaultView: WelcomeView(
          regView: const RegView(),
          loginPaths: NannyConsts.availablePaths,
        ),
      ),
    ),
  );
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
      theme: NannyTheme.appTheme,
      // home: firstScreen,
      home: const TestView(),
    );
  }
}

// На случай, если Пятисотый забыл сертификаты обновить
  
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}