import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unity/data/app_exceptions/app_exception.dart';
import '../../../../../model/firebase/message_model.dart';

class UsersChat {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final storeRef =
      FirebaseFirestore.instance.collection("unity_user_chatroom");

  static getChatRoomId(String senderUID, String receiverUID) {
    List<String> ids = [senderUID, receiverUID];
    ids.sort();
    String chatRoomId = ids.join('_');
    return chatRoomId;
  }

  static Stream<List<MessageModel>> getAllMessage(
      String senderUID, String receiverUID) {
    // getAllImages(receiverUID);
    final chatRoomId = getChatRoomId(senderUID, receiverUID);
    // debugPrint(chatRoomId);
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");
    // Converting
    return messageCollection.snapshots().map((querySnapshot) {
      final List<MessageModel> messageList = [];
      for (final doc in querySnapshot.docs) {
        final Map<String, dynamic> data = doc.data();
        final MessageModel message = MessageModel.fromJson(data);
        messageList.add(message);
      }
      return messageList;
    });
  }

  static getAllImages(String receiver) {
    String currentUser = _auth.currentUser!.uid;

    UsersChat.getAllMessage(currentUser, receiver).map((messages) {
      debugPrint(messages.toString());
      messages.map((message) {
        debugPrint(message.message.toString());
        return message;
      }).toList();
    });
    // debugPrint(chats.toString());

  }

  static Future<void> sendMessage(MessageModel message) async {
    final chatRoomId = getChatRoomId(message.senderUID, message.receiverUID);
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");
    messageCollection
        .doc(message.chatID)
        .set(message.toMap())
        .then((value) {
      debugPrint("message sent");
    }).onError((error, stackTrace) {
      throw InvalidUrl(error.toString());
    });
  }

  static Future<void> updateMessageStatus(MessageModel message) async {
    final chatRoomId = getChatRoomId(message.senderUID, message.receiverUID); // Extract chatRoomId from chatID
    // debugPrint("ChatRoomId is $chatRoomId");
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");
    final messageDoc = await messageCollection.doc(message.chatID).get();
    // debugPrint("Message is going to update");
    if (messageDoc.exists) {
      // Update the message's status field
      // debugPrint("Doc exist");
      await messageCollection
          .doc(message.chatID)
          .update({ "status": message.status, "readTime": message.readTime, "deliveredTime" : message.deliveredTime}).then((value) async {
        // debugPrint("Message Updated");
      }).onError((error, stackTrace) {
        // debugPrint("Message Updation failed");
      });
    }
  }

  static updateMessageStar(MessageModel message)async {
    final chatRoomId = getChatRoomId(message.senderUID, message.receiverUID);
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");
    final messageDoc = await messageCollection.doc(message.chatID).get();
    if (messageDoc.exists) {
      await messageCollection
          .doc(message.chatID)
          .update({ "star": message.star}).then((value) async {
        debugPrint("Star Updated");
      }).onError((error, stackTrace) {
        debugPrint("Star Updation failed");
      });
    }
  }

  static Future<void> deleteMessage(
      String receiver, String sender, String chatID, int code) async {
    final chatRoomId =
        getChatRoomId(sender, receiver); // Extract chatRoomId from chatID
    // debugPrint("ChatRoomId is $chatRoomId");
    final messageCollection = storeRef.doc(chatRoomId).collection("messages");
    final messageDoc = await messageCollection.doc(chatID).get();
    // debugPrint("Message is going to update");
    if (messageDoc.exists) {
      // Update the message's status field
      // debugPrint("Doc exist");
      await messageCollection
          .doc(chatID)
          .update({"visibleNo": code}).then((value) {
        debugPrint("Message deleted");
      }).onError((error, stackTrace) {
        // debugPrint("Message Updation failed");
      });
    }
  }

  static getCurrentUserLastMessage(String receiverUID)
  {
    final chatRoomId = getChatRoomId(_auth.currentUser!.uid, receiverUID);
    final messageCollection = storeRef.doc(chatRoomId).collection("messages").limit(1).snapshots();
  }
}
