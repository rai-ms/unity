import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/firebase/user_profile_model.dart';
import '../utils/app_helper/firebase_database/fireStore/user_profile_fireStore/users_profile_fireStore.dart';
import '../utils/routes/route_name.dart';

class SplashScreenServices {
  static UserProfileModel? userProfileModel;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;
  static checkAuthentication(BuildContext context) async {

    var user = _auth.currentUser;
    if (user != null) {
      UsersProfileFireStore.getCurrentUserProfile(user.uid).map((event){
        userProfileModel = event;
        debugPrint("ABCD$userProfileModel");
      });
      await Future.delayed(const Duration(seconds: 3));
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.homeView, (route) => false);
    } else {
      await Future.delayed(const Duration(seconds: 3));
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.introView, (route) => false);
    }
  }
}
