import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unity/utils/routes/route_name.dart';

class UnknownPageService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static checkAuthHomePage(BuildContext context) {
    if (_auth.currentUser != null)
    {
      return;
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.loginView, (route) => false);
    }
  }
}
