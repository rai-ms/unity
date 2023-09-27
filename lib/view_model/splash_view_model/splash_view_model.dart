import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashViewModel extends ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  isUserLogin(){
    final user = firebaseAuth.currentUser;
    if(user != null){
      return true;
    }
    return false;
  }
}
