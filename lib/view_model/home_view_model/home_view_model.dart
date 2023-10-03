import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../model/firebase/message_model.dart';
import '../../model/firebase/user_profile_model.dart';
import '../../utils/app_helper/firebase_database/fireStore/chat_fireStore/users_chat.dart';
import '../../utils/app_helper/firebase_database/fireStore/user_profile_fireStore/users_profile_fireStore.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UsersProfileFireStore? user;
  signOut() {
    _auth.signOut();
  }

  updateAllMessage(String receiver) {
    String currentUser = _auth.currentUser!.uid.toString().trim();
    String now = DateTime.now().toString();
    Stream<List<MessageModel>> chats = UsersChat.getAllMessage(currentUser, receiver);
    chats.map((messages) async {
      for(MessageModel message in messages)
      {
        if(message.senderUID != _auth.currentUser!.uid &&  message.status == 0){
          message.deliveredTime = now;
          message.status = 1;
          await UsersChat.updateMessageStatus(message).then((value){
            debugPrint("Updation on database is success");
          }).onError((error, stackTrace){
            debugPrint("Updation on database is failed");
          });
        }
      }
    });
    return chats;
  }
  // List<UserProfileModel> _usersProfile = [];
  // set usersProfile(value) => this
  // List<UserProfileModel> get usersProfile {
  //   UsersProfileFireStore.getAllUsers().listen((List<UserProfileModel> users) {
  //     for(UserProfileModel userProf in users){
  //       if(userProf.uid != _auth.currentUser!.uid){
  //         _usersProfile.add(userProf);
  //       }
  //     }
  //   });
  //   return _usersProfile;
  // }

  Stream<List<UserProfileModel>> getAllUser() {
    // debugPrint("This code is running and fetching the users profile registered in the app");
   Stream<List<UserProfileModel>> profiles = UsersProfileFireStore.getAllUsers();
    // debugPrint("Profiles fetched! $profiles");
   profiles.map((List<UserProfileModel> usersProfile)async {
     debugPrint("This code is running");
     List<UserProfileModel> users = [];
     for(UserProfileModel profileModel in usersProfile){
       await updateAllMessage(profileModel.uid);
      if (profileModel.uid != _auth.currentUser!.uid) {
        {
          users.add(profileModel);
        }
      }
     }
     debugPrint(users.length.toString());
     return users;
   });

    return profiles;
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
