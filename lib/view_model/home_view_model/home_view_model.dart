import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/app_helper/firebase_database/firestore/chat_firestore/users_chat.dart';

class HomeViewModel extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  signOut() {
    _auth.signOut();
  }
}
