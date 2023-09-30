import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unity/model/firebase/message_model.dart';

import '../../utils/app_helper/firebase_database/firestore/chat_firestore/users_chat.dart';

class ChatViewModel extends ChangeNotifier {
  TextEditingController messCont = TextEditingController();
  FocusNode messFocus = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  sendMessage(String receiver) {
    String mess = messCont.text.toString().trim();
    messCont.clear();
    DateTime now = DateTime.now();
    String time = now.toString();
    String chatID = now.millisecondsSinceEpoch.toString();
    if (mess.isNotEmpty) {
      UsersChat.sendMessage(MessageModel(
        message: mess,
        senderUID: _auth.currentUser!.uid,
        time: time,
        receiverUID: receiver,
        chatID: chatID,
        status: "u",
      ));
    }
  }

  getAllMessage(String receiver) {
    String currentUser = _auth.currentUser!.uid;
    String now = DateTime.now().toString();

    Stream<List<MessageModel>> chats =
        UsersChat.getAllMessage(currentUser, receiver).map((messages) {
      // debugPrint(messages.toString());
      return messages.map((message) {
        // debugPrint(message.message.toString());
        if (message.senderUID != currentUser && message.status == "u") {
          message.status = now;
          // debugPrint(now.toString() + message.chatID);
          UsersChat.updateMessageStatus(
                  message.senderUID, message.receiverUID, now, message.chatID)
              .then((value) {})
              .onError((error, stackTrace) {});
        }
        return message;
      }).toList();
    });
    // debugPrint(chats.toString());
    return chats;
  }

  deleteMessage(MessageModel messageModel, int code) {
    UsersChat.deleteMessage(messageModel.receiverUID, messageModel.senderUID,
            messageModel.chatID, code)
        .then((value) {})
        .onError((error, stackTrace) {});
  }
}
