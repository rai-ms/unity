import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../model/firebase/message_model.dart';
import '../../model/firebase/user_profile_model.dart';
import '../../utils/app_helper/firebase_database/firestore/chat_firestore/users_chat.dart';
import '../../utils/app_helper/firebase_database/firestore/user_profile_firestore/users_profile_firestore.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UsersProfileFireStore? user;
  signOut() {
    _auth.signOut();
  }

  int countUnseenMessages = 0;

  getAllMessage(String receiver) {
    countUnseenMessages = 0;
    String currentUser = _auth.currentUser!.uid.toString().trim();
    String now = DateTime.now().toString();
    Stream<List<MessageModel>> chats =
        UsersChat.getAllMessage(currentUser, receiver).map((messages) {
      return messages.map((message) {
        if (message.senderUID != currentUser) {
          if (message.deliveryStatus == "0") {
            message.deliveryStatus = now;
            countUnseenMessages++;
          } else if (message.status == "u") {
            countUnseenMessages++;
          }
        }
        return message;
      }).toList();
    });
    return chats;
  }

  getAllUser() {
    return UsersProfileFireStore.getAllUsers();
  }

// UserProfileModel
  @override
  void dispose() {
    // TODO: implement dispose
    isLogin = false;
    super.dispose();
  }

  UserProfileModel? _appLoginUser;
  bool isLogin = false;
  UserProfileModel? get appLoginUser {
    if (!isLogin) {
      isLogin = true;
      getCurrentUser();
    }
    return _appLoginUser;
  }

  void getCurrentUser() {
    UsersProfileFireStore.getCurrentUserProfile(_auth.currentUser!.uid)
        .listen((profile) {
      // This callback will be called whenever the profile data changes or is fetched.
      if (profile != null) {
        // Profile data is available.
        _appLoginUser = profile;
      } else {
        // Profile data is not available (e.g., if the document doesn't exist).
        _appLoginUser = null;
      }
      // Notify listeners (if this method is part of a ChangeNotifier).
      notifyListeners();
    });
  }
}
