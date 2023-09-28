import 'package:flutter/material.dart';
import 'package:unity/view_model/splash_view_model/splash_view_model.dart';
import '../utils/routes/route_name.dart';

class SplashScreenServices {
  static checkAuthentication(BuildContext context) async {
    SplashViewModel md = SplashViewModel();
    if (md.isUserLogin()) {
      await Future.delayed(const Duration(seconds: 3));
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.homeView, (route) => false);
    }
    else{
      await Future.delayed(const Duration(seconds: 3));
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.introView, (route) => false);
    }
  }

}
