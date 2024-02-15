import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/constants.dart';
import 'package:nanny_driver/views/reg.dart';

class PartnerHomeVM extends ViewModelBase {
  PartnerHomeVM({
    required super.context, 
    required super.update,
  });

  void navigateToProfile() => Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => ProfileView(
      logoutView: WelcomeView(
        regView: const RegView(), 
        loginPaths: NannyConsts.availablePaths,
      ),
    )),
  );
}