import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  signOut() {
    _auth.signOut();
  }
}
