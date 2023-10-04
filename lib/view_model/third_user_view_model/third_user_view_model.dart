import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/utils/app_helper/firebase_database/fireStore/chat_fireStore/users_chat.dart';

class ThirdUserViewModel extends ChangeNotifier
{
  static UserProfileModel? thirdUser;

  Stream<List<MessageModel>>? getAllImages() {
    final currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    List<MessageModel> images = [];

    UsersChat.getAllMessage(thirdUser!.uid, FirebaseAuth.instance.currentUser!.uid).map((event)
    {
      images.clear();
      debugPrint("Going to fetch Images list");
      event.map((e){
        if(e.img!.length > 1){
          images.add(e);
        }
      });
      return images;
    });

    // return  UsersChat.getAllMessage(thirdUser!.uid, FirebaseAuth.instance.currentUser!.uid);
  }

}