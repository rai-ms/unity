import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../model/firebase/message_model.dart';
import '../../model/firebase/user_profile_model.dart';
import '../../utils/app_helper/firebase_database/firestore/chat_firestore/users_chat.dart';
import '../../utils/app_helper/firebase_database/firestore/user_profile_firestore/users_profile_fireStore.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UsersProfileFireStore? user;
  signOut() {
    _auth.signOut();
  }

  int countUnseenMessages = 0;
  List<int> countMessage = [];

  Stream<List<MessageModel>> getAllMessage(String receiver) {
    String currentUser = _auth.currentUser!.uid;
    String now = DateTime.now().toString();

    Stream<List<MessageModel>> chats =
    UsersChat.getAllMessage(currentUser, receiver).map((messages) {
      // debugPrint(messages.toString());
      return messages.map((message) {
        // debugPrint(message.message.toString());
        if (message.senderUID != currentUser && message.status < 2) {
          message.deliveredTime = now;
          message.status = 1;
          // debugPrint(now.toString() + message.chatID);
          UsersChat.updateMessageStatus(message)
              .then((value) {
            debugPrint("Message Updated:"+now.toString() + message.chatID);
          })
              .onError((error, stackTrace) {
            debugPrint("Unable to Updated Message:" +now.toString() + message.chatID);
          });
        }
        return message;
      }).toList();
    });
    // debugPrint(chats.toString());
    return chats;
  }

  Stream<List<UserProfileModel>> getAllUser() {
    Stream<List<UserProfileModel>> usersStream =  UsersProfileFireStore.getAllUsers();
    return usersStream;
  }


// UserProfileModel
  @override
  void dispose() {
    isLogin = false;
    SystemChannels.lifecycle.setMessageHandler((message) async
    {
      debugPrint(message);
      if(message.toString().contains("pause")) {
        // set here for last active time
        setUserStatus(false);
      }
      else if(message.toString().contains('resume')){
        // set here for Online
        setUserStatus(true);
      }
      return Future.value(message);
    });
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

  static setUserStatus(bool status)
  {
    UsersProfileFireStore.updateStatus(status);
  }

}
