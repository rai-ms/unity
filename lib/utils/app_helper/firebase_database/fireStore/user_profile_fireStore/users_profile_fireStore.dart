import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static Stream<dynamic> getAllUser() {
    final fireStoreStream = storeRef.snapshots();
    return fireStoreStream;
  }

  static Stream<List<UserProfileModel>> getAllUsers() {
    final fireStoreStream = storeRef.snapshots();
    return fireStoreStream.map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final List<UserProfileModel> users = [];
      for (final DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data()!;
        users.add(UserProfileModel.fromJson(data));
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
  static updateStatus(bool status) async
  {
    final currentUserUID = _auth.currentUser?.uid;
    if (currentUserUID != null) {
      final userDoc = FirebaseFirestore.instance.collection("users").doc(currentUserUID);
      await userDoc.update({"onLineStatus": "$status"}).then((value){}).onError((error, stackTrace){});
    }
  }

  static Future<bool> getStatus(String uID) async {
    final userDoc = FirebaseFirestore.instance.collection("users").doc(uID);
    final snapshot = await userDoc.get();
    final data = snapshot.data();
    if (data != null && data.containsKey("onLineStatus")) {
      return data["onLineStatus"] ?? false; // Return the online status or false if not present
    }
      return false; // Return false if the document doesn't exist or doesn't contain the field
  }

}
