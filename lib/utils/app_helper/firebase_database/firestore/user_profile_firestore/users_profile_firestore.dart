import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unity/data/app_exceptions/app_exception.dart';

import '../../../../../model/firebase/user_profile_model.dart';

class UsersProfileFireStore {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storeRef = FirebaseFirestore.instance.collection("users");

  /// This is done to
  Future<bool?> createUserAccount(
      String email, String pass) async {
    await _auth
        .createUserWithEmailAndPassword(
            email: email.toString().trim(), password: pass.trim())
        .then((value) {
      UserCredential u = value;
      User? user = u.user;
      debugPrint("Cred Added on database $user");
      return true;
    }).onError((error, stackTrace) {
      debugPrint(
          "Error Occurred While Account Creation Email:$email\nError:$error");
      throw UnableToLogin;
    });
  }

  Future<bool> loginUser(String email, String pass) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: email.trim(), password: pass.trim())
          .then((value) {
        return true;
      }).onError((error, stackTrace) {
        return false;
      });
    } catch (e) {
      debugPrint("Error Occurred While login \nError:$e");
      return false;
    }
    return false;
  }

  Future<bool> registerUser(UserProfileModel user) async {
    await storeRef.doc(user.uid).set(user.toMap()).then((value) {
      debugPrint("Successfully Registered");
      return true;
    }).onError((error, stackTrace) {
      debugPrint("Error occurred while Registration \nError: $error");
      return false;
    });
    return false;
  }

  static Stream<dynamic> getAllUser() {
    final firestoreStream =
        FirebaseFirestore.instance.collection("users").snapshots();
    return firestoreStream;
  }
}
