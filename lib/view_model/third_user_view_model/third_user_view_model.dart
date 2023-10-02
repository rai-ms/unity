import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/utils/app_helper/firebase_database/fireStore/chat_fireStore/users_chat.dart';

class ThirdUserViewModel extends ChangeNotifier
{
  static UserProfileModel? thirdUser;

  Future<List<MessageModel>> getAllImages() async {
    final currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    if (thirdUser == null || currentUserUID == null) {
      // Return an empty list if either thirdUser or currentUserUID is null
      return [];
    }

    final messageList = await UsersChat.getAllMessage(thirdUser!.uid, currentUserUID).first;

    // Filter and return only messages with images
    final imageMessages = messageList.where((message) => message.img != null).toList();

    return imageMessages;
  }



}