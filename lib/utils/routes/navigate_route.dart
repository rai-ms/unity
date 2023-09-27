import 'package:flutter/material.dart';
import 'package:unity/utils/routes/route_name.dart';
import 'package:unity/view/signup_view/signup_view.dart';

import '../../view/home_view/home_view.dart';
import '../../view/intro_view/intro_view.dart';
import '../../view/loginView/login_view.dart';
import '../../view/splash_view/splash_view.dart';

class NavigateRoute {
  static Route<dynamic> onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeView:
        return MaterialPageRoute(builder: (context) => const HomeView());
      case RouteName.splashscreen:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case RouteName.loginView:
        return MaterialPageRoute(builder: (context) => const LoginView());
      case RouteName.introView:
        return MaterialPageRoute(builder: (context) => const IntroView());
      case RouteName.signupView:
        return MaterialPageRoute(builder: (context) => const SignUpView());
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(
                    child: Text("Error 404"),
                  ),
                ));
    }
  }
}
