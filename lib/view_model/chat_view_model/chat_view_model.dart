import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unity/model/firebase/message_model.dart';

import '../../utils/app_helper/firebase_database/firestore/chat_firestore/users_chat.dart';

class ChatViewModel extends ChangeNotifier
{
  TextEditingController messCont = TextEditingController();
  FocusNode messFocus = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  sendMessage(String receiver)
  {
    String mess = messCont.text.toString().trim();
    messCont.clear();
    DateTime now =  DateTime.now();
    String time = now.toString();
    String chatID = now.millisecondsSinceEpoch.toString();
    if(mess.isNotEmpty){
      UsersChat.sendMessage(MessageModel(message: mess, senderUID: _auth.currentUser!.uid, time: time, receiverUID: receiver, chatID: chatID, status: "u",));
    }
  }

  getAllMessage(String receiver){
    String sender =  _auth.currentUser!.uid.toString().trim();
    return UsersChat.getAllMessage(sender, receiver);
  }
}