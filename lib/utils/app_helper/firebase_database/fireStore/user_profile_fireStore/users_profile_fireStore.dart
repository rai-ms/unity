import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unity/data/app_exceptions/app_exception.dart';
import '../../../../../model/firebase/user_profile_model.dart';


class UsersProfileFireStore {

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final storeRef = FirebaseFirestore.instance.collection("users");

  /// This is done to create the account of the user, to get the UID
  Future<bool?> createUserAccount(String email, String pass) async {
    await _auth
        .createUserWithEmailAndPassword(
            email: email.toString().trim(), password: pass.toString().trim())
        .then((value) {
      UserCredential u = value;
      User? user = u.user;
      // debugPrint("Cred Added on database $user");
      return true;
    }).onError((error, stackTrace) {
      // debugPrint(
      //     "Error Occurred While Account Creation Email:$email\nError:$error");
      throw UnableToLogin;
    });
    return null;
  }


  Future<bool> loginUser(String email, String pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: pass.trim()).then((value)
      {
        return true;
      }).onError((error, stackTrace) {
        return false;
      });
    } catch (e) {
      // debugPrint("Error Occurred While login \nError:$e");
      return false;
    }
    return false;
  }


  Future<bool> registerUser(UserProfileModel user) async {
    await storeRef.doc(user.uid).set(user.toMap()).then((value) {
      // debugPrint("Successfully Registered");
      return true;
    }).onError((error, stackTrace) {
      // debugPrint("Error occurred while Registration \nError: $error");
      return false;
    });
    return false;
  }


  /// This method will returns all the users
  static Stream<dynamic> getAllUser() {
    final fireStoreStream = storeRef.snapshots();
    return fireStoreStream;
  }

  getBlockedUsers()
  {
    final currentUserSnapShot = storeRef.doc(_auth.currentUser!.uid.toString()).snapshots();
    final data = currentUserSnapShot.map((event){

    });
  }

  /// This method will returns all the users except current user
  static Stream<List<UserProfileModel>> getAllUsers() {
    final fireStoreStream = storeRef.snapshots();
    return fireStoreStream.map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final List<UserProfileModel> users = [];
      for (final DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data()!;
        UserProfileModel user = UserProfileModel.fromJson(data);
        if(user.uid != _auth.currentUser!.uid) users.add(user);
      }
      return users;
    });
  }

  static Stream<UserProfileModel?> getCurrentUserProfile(String currentUserUID) {
    final fireStoreStream = storeRef.doc(currentUserUID).snapshots();
    return fireStoreStream.map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists)
      {
        final Map<String, dynamic> data = snapshot.data()!;
        return UserProfileModel.fromJson(data);
      }
      else
      {
        // If the user profile document doesn't exist, return null.
        return null;
      }
    });
  }
  // Update user's online status to "online" when they log in
  static updateStatus(String status) async
  {
    final currentUserUID = _auth.currentUser?.uid;
    if (currentUserUID != null) {
      final userDoc = FirebaseFirestore.instance.collection("users").doc(currentUserUID);
      await userDoc.update({"onLineStatus": "$status"}).then((value){}).onError((error, stackTrace){});
    }
  }

  static List<String> blockUIDs = [];

  static bool isContainsID(String id){
    for(var i in blockUIDs){
      if(i == id){
        return true;
      }
    }
    return false;
  }

  /// This method is used to block/unblock the user, it add/remove the blocked UID in the List of UserModel BlockedUID
  static blockUser(String userUID ,{bool remove = false}) async
  {
    blockUIDs.clear();
    final currentUserUID = _auth.currentUser?.uid;

    if (currentUserUID != null) {
      await FirebaseFirestore.instance.collection("users").doc(currentUserUID).get().then((value){
        debugPrint("Before Try is running");
        try {
          // Map<String, dynamic> mp = value.data() as Map<String, dynamic>;
          // List<dynamic> listUIDS = mp['blockedUID'];
          debugPrint("Try is running");
          final usersProfile = UserProfileModel.fromJson(value.data() as Map<String, dynamic>);
          blockUIDs = usersProfile.blockedUID;
          debugPrint("The length is ${blockUIDs.length.toString()}");
        }
        catch (e)
        {
          debugPrint("Exception occurred: $e");
        }

        // debugPrint(value.data().toString() ?? "");
      });
      debugPrint("checking for if");
      if(!remove){
        debugPrint("Before add length ${blockUIDs.length.toString()}");
        if(!isContainsID(userUID)){
          blockUIDs.add(userUID);
        }
        else
          {
            debugPrint("User already blocked");
          }

        debugPrint("ID Added");
      }
      else
      {
        debugPrint("checking for else");
        for(int i = 0; i < blockUIDs.length; ++i){
          if(blockUIDs[i] == userUID){
            blockUIDs.removeAt(i);
            debugPrint("ID Removed");
            break;
          }
        }
      }
      debugPrint(blockUIDs.length.toString() + "This is the lenght of the blocked UIds");
      FirebaseFirestore.instance.collection("users").doc(currentUserUID).update({"blockedUID":blockUIDs}).then((value) {}).onError((error, stackTrace){});
    }
  }

  static Stream<bool> getStatus(String uID) {
    final userDoc = FirebaseFirestore.instance.collection("users").doc(uID);
    final streamController = StreamController<bool>();
    userDoc.snapshots().listen((snapshot) {
      final data = snapshot.data();
      if (data != null && data.containsKey("onLineStatus")) {
        streamController.add(data["onLineStatus"]  == "true"? true: false);
        if(data["onLineStatus"]  != "true"){
          offlineTime = data["onLineStatus"];
        }
      }
      else
      {
        streamController.add(false);
      }
    });
    return streamController.stream;
  }

  static String offlineTime = "";

}
