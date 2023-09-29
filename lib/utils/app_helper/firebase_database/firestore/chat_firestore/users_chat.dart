import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unity/data/app_exceptions/app_exception.dart';
import '../../../../../model/firebase/message_model.dart';

class UsersChat
{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final storeRef = FirebaseFirestore.instance.collection("unity_user_chatroom");

  static getChatRoomId(String senderUID, String receiverUID)
  {
    List<String> ids = [senderUID, receiverUID];
    ids.sort();
    String chatRoomId = ids.join('_');
    return chatRoomId;
  }

  static Stream<List<MessageModel>> getAllMessage(String senderUID, String receiverUID) {
    final chatRoomId = getChatRoomId(senderUID, receiverUID);
    debugPrint(chatRoomId);
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");
    // Converting
    return messageCollection.orderBy("time").snapshots().map((querySnapshot) {
      // debugPrint(querySnapshot.docs.toString());
      final List<MessageModel> messageList = [];
      for (final doc in querySnapshot.docs) {
        final Map<String, dynamic> data = doc.data();
        // debugPrint("Message:"+data.toString());
        final MessageModel message = MessageModel.fromJson(data);
        messageList.add(message);
      }
      return messageList;
    });
  }

  static Future<void> sendMessage(MessageModel message) async {
    final chatRoomId = getChatRoomId(message.senderUID, message.receiverUID);
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");
    messageCollection.doc(message.chatID).set(message.toMap()).then((value)
    {

    }).onError((error, stackTrace){
        throw InvalidUrl(error.toString());
    });
  }
}