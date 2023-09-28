import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");

    return messageCollection.orderBy("time").snapshots().map((querySnapshot) {
      final List<MessageModel> messageList = [];
      for (final doc in querySnapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final MessageModel message = MessageModel.fromJson(data);
        messageList.add(message);
      }
      return messageList;
    });
  }

  static Future<void> sendMessage(MessageModel message) async {
    final chatRoomId = getChatRoomId(message.senderUID, message.receiverUID);
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    messageCollection.doc(time).set(message.toMap()).then((value)
    {

    }).onError((error, stackTrace){

    });
    // await messageCollection.add(message.toMap())
  }
  /// No need to create chat room, if chat room  not exist, it will create automatically
  // static Future<void> createChatRoom(String senderUID, String receiverUID) async {
  //   final chatRoomId = getChatRoomId(senderUID, receiverUID);
  //   String time = DateTime.now().millisecondsSinceEpoch.toString();
  //   // Check if the chat room already exists, and create it, if not
  //   final chatRoomDoc = storeRef.doc(chatRoomId);
  //
  //   if (!(await chatRoomDoc.get()).exists) {
  //     // Create the chat room with some initial data if needed
  //     MessageModel model = MessageModel(message: "Welcome to the Unity", senderUID: senderUID, time: time, receiverUID: receiverUID, chatID: chatRoomId, status: "Welcome");
  //     await chatRoomDoc.set(model.toMap()).then((value)
  //     {
  //     }).onError((error, stackTrace){
  //       throw FetchDataException;
  //     });
  //   }
  // }
}