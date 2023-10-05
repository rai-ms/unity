import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:unity/utils/routes/route_name.dart';
import '../../model/firebase/message_model.dart';
import '../../model/firebase/user_profile_model.dart';
import '../../utils/app_helper/firebase_database/fireStore/chat_fireStore/users_chat.dart';
import '../../utils/app_helper/firebase_database/fireStore/user_profile_fireStore/users_profile_fireStore.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UsersProfileFireStore? user;
  signOut(BuildContext context) async {
    HomeViewModel.setUserStatus(DateTime.now().toString());
    await Future.delayed(Duration(seconds: 2));
    _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, RouteName.loginView, (route)=> false);
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
  static UserProfileModel? _appLoginUser;
  bool isLogin = false;
  UserProfileModel? get appLoginUser {
    if (!isLogin) {
      isLogin = true;
      getCurrentUser();
    }
    return _appLoginUser;
  }
  static setUser(UserProfileModel? setUser){
    _appLoginUser = setUser;
  }

  static List<String> blockuID = [];
  static setBlockUID()
  {
    blockuID = _appLoginUser!.blockedUID;
  }

  bool isContains(String id){
    for(String i in blockuID){
      if(i == id) return true;
    }
    return false;
  }

  Stream<List<UserProfileModel>> getAllUser()
  {

    // UserProfileModel? currentUser = _appLoginUser ?? appLoginUser!;
    // blockuID = _appLoginUser!.blockedUID;
    // debugPrint("This code is running and fetching the users profile registered in the app");
   Stream<List<UserProfileModel>> profiles = UsersProfileFireStore.getAllUsers();
    // debugPrint("Profiles fetched! $profiles");
   profiles.map((List<UserProfileModel> usersProfile)async {
     // debugPrint("This code is running");
     List<UserProfileModel> users = [];
     for(UserProfileModel profileModel in usersProfile){
       await updateAllMessage(profileModel.uid);
      if (profileModel.uid != _auth.currentUser!.uid && !isContains(profileModel.uid)) {
          // debugPrint("Item Added");
          users.add(profileModel);
      }
      else {
        // debugPrint("Item not Added");
      }
     }
     // debugPrint(users.length.toString());
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
        setUserStatus(DateTime.now().toString());
      }
      else if(message.toString().contains('resume')){
        // set here for Online
        setUserStatus("true");
      }
      return Future.value(message);
    });
    super.dispose();
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

  Stream<UserProfileModel?> getUserProfileData(String uID){
    return UsersProfileFireStore.getCurrentUserProfile(uID);
  }

  static setUserStatus(String status)
  {
    UsersProfileFireStore.updateStatus(status);
  }

  List<UserProfileModel>? removeBlockedUsers(List<UserProfileModel>? list){
    UserProfileModel? currentUser = _appLoginUser;
    List<String> blockedIDs = currentUser?.blockedUID ?? [""];
    for(String id in blockedIDs){
      if(list == null) return null;
      for(int i = 0; i < list.length; ++i){
        if(list[i].uid == id){
          list.removeAt(i);
        }
      }
    }
    return list;
  }

}
