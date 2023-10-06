import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/res/components/custom_toast.dart';
import '../../utils/app_helper/firebase_database/fireStore/user_profile_fireStore/users_profile_fireStore.dart';
import '../../utils/app_helper/firebase_database/fireStore/chat_fireStore/users_chat.dart';
import '../../utils/app_helper/firebase_database/storage_firebase/firebase_storage_image_upload.dart';

class ChatViewModel extends ChangeNotifier {
  TextEditingController messCont = TextEditingController();
  FocusNode messFocus = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  FirebaseAuth get auth => _auth;
  sendMessage(String receiver, {bool isImage = false, String imageUrl = ""}) {
    String mess = messCont.text.toString().trim();
    messCont.clear();
    DateTime now = DateTime.now();
    String time = now.toString();
    String chatID = now.millisecondsSinceEpoch.toString();
    if (mess.isNotEmpty || isImage) {
      UsersChat.sendMessage(MessageModel(
        message: !isImage?mess:"",
        senderUID: _auth.currentUser!.uid,
        time: time,
        receiverUID: receiver,
        chatID: chatID,
        readTime: "u",
        status: 0,
        sentTime: time,
        visibleNo: 3,
        img: isImage?imageUrl:""
      ));
    }
  }


  forwardMessage(List<MessageModel> messageModel, String receiver) {
    for(int i = 0; i < messageModel.length; ++i){
      DateTime now = DateTime.now();
      String time = now.toString();
      String chatID = now.millisecondsSinceEpoch.toString();
      messageModel[i].chatID = chatID;
      messageModel[i].time = time;
      messageModel[i].sentTime = time;
      messageModel[i].isForwarded = 1 + messageModel[i].isForwarded;
      messageModel[i].senderUID = _auth.currentUser!.uid;
      messageModel[i].receiverUID = receiver;
      messageModel[i].visibleNo = 3;
      messageModel[i].status = 0;
      messageModel[i].star = 0;
      UsersChat.sendMessage(messageModel[i]).then((value) {
        debugPrint("Message Sent $i");
      }).onError((error, stackTrace){
        debugPrint("Message not Sent $i");
      });
    }

    selectedMessages.clear();
    notifyListeners();
  }


  pickAndSendImage(String receiver) async {
    // debugPrint("pick going to upload");
    await requestPermission(receiver);

  }

  Future<void> requestPermission(String receiver) async {
    PermissionStatus status = await Permission.camera.request();

    // Check the permission status
    if (status.isGranted) {
      // debugPrint("Permission Granted");
      await fetchImage();
      // debugPrint("Image Fetched going to upload");
      await uploadImage(receiver);
      // debugPrint("Image Uploaded");

    } else {

      // debugPrint("Permission not granted in else");
      // debugPrint("Going to fetch image in else");
      await fetchImage();
      // debugPrint("Image fetched going to upload in else");
      await uploadImage(receiver);
      // debugPrint("Going to upload in else");
      // openAppSettings();
    }
  }

  uploadImage(String receiver) async {
    if (!isPicked) return;
    User user = _auth.currentUser!;
    String timeId = DateTime.now().microsecondsSinceEpoch.toString();

    String url = await FirebaseImageUpload.sendImageWithSenderAndReceiverChatIDAndTimeOnStorage(getChatID(receiver, user.uid.toString()), timeId, pickedImage);
    sendMessage(receiver, isImage: true, imageUrl: url);
    // await UsersChat.sendMessage(MessageModel(message: "", senderUID: user.uid, time: timeId, receiverUID: receiver, chatID: timeId, status: 0, sentTime: timeId, img: url)).then((value){
    //   debugPrint("Success uploading image on database");
    //
    // }).onError((error, stackTrace){
    //   debugPrint("Error while uploading image on database");
    // });
    isPicked = false;
    pickedImage = null;
  }

  String getChatID(String r, String s) {

    List<String> l = [r,s];
    l.sort();
    // debugPrint("returning chat id");
    return l.join("_");

  }

  bool isUploaded = true;

  bool isPicked = false;

  File? pickedImage;
  fetchImage() async {
    try {
      XFile? pickImage = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxHeight: 200, maxWidth: 300);

      if (pickImage == null) return;
      final tmpImage = File(pickImage.path);
      pickedImage = tmpImage;
      isPicked = true;
      debugPrint("image fetched $pickedImage");
    } on Exception catch (_)
    {}
  }

  Stream<List<MessageModel>> getAllMessage(String receiver) {
    String currentUser = _auth.currentUser!.uid;
    String now = DateTime.now().toString();

    Stream<List<MessageModel>> chats =
        UsersChat.getAllMessage(currentUser, receiver).map((messages) {
      // debugPrint(messages.toString());
      return messages.map((message) {
        // debugPrint(message.message.toString());
        if (message.senderUID != currentUser && message.status < 2) {
          message.readTime = now.toString();
          message.status = 2;
          if(message.deliveredTime != "")message.deliveredTime = now.toString();
          // debugPrint(now.toString() + message.chatID);
          UsersChat.updateMessageStatus(message)
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

  bool isOnline = false;
  getStatus(String uID) {
     UsersProfileFireStore.getStatus(uID).listen((isActive)
     {
       if(isOnline != isActive)
       {
         isOnline = isActive;
         notifyListeners();
       }
     });
     return UsersProfileFireStore.getStatus(uID);
  }


  List<MessageModel> selectedMessages = [];
  void addMessage(MessageModel messageModel){
    selectedMessages.add(messageModel);
  }
  void removeMessage(int index){
    selectedMessages.removeAt(index);
  }
  int isContains(MessageModel messageModel){
    for(int i = 0; i < selectedMessages.length; ++i){
      if(selectedMessages[i].chatID == messageModel.chatID){
        return i;
      }
    }
    return -1;
  }
  removeAllFromList(){
    selectedMessages.clear();
    notifyListeners();
  }
  void toggleMessage(MessageModel messageModel)
  {
    int isContain = isContains(messageModel);
    if(isContain == -1)
    {
      addMessage(messageModel);
      debugPrint("Added");
      notifyListeners();
    }
    else
    {
      debugPrint("removed");
      removeMessage(isContain);
      notifyListeners();
    }
    for(var mes in selectedMessages){
      debugPrint(mes.message);
    }
    debugPrint("${selectedMessages.length}");
  }

  bool isAvailableToDeleteForAll() {
    String sender = _auth.currentUser!.uid.toString();
    for(int i = 0; i < selectedMessages.length; ++i){
      if(selectedMessages[i].senderUID != sender){
        return false;
      }
    }
    return true;
  }

  void deleteForMe(){
    deleteMessages(code:1);
  }

  void deleteForAll()
  {
    deleteMessages(code: 0);
  }

  void deleteMessages({int code = 0}){
    if(code == 0)
      {
        // Delete for all for sender Message only
        for(int i = 0; i < selectedMessages.length; ++i)
        {
          deleteMessage(selectedMessages[i], 0);
        }
      }
    else
      {

        for(int i = 0; i < selectedMessages.length; ++i)
        {
          // If there exist any receiver message
          if(selectedMessages[i].senderUID != _auth.currentUser!.uid) {
            if(selectedMessages[i].visibleNo != 3) {
              deleteMessage(selectedMessages[i], 0);
            }
            else {
              deleteMessage(selectedMessages[i], 2);
            }
          }
          else {
            if(selectedMessages[i].visibleNo != 3) {
              deleteMessage(selectedMessages[i], 0);
            }
            else {
              deleteMessage(selectedMessages[i], 1);
            }
          }
        }
      }
    removeAllFromList();
  }

  bool isAvailableToStar(){
    if(selectedMessages[0].senderUID != _auth.currentUser!.uid){
      return true;
    }
    return false;
  }

  toggleStar()
  {
    if(selectedMessages[0].star  == 1){
      selectedMessages[0].star  = 0;
    }
    else
    {
      selectedMessages[0].star  = 1;
    }
    try{
      UsersChat.updateMessageStar(selectedMessages[0]);
      selectedMessages.clear();
    } catch (e){
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  Future<void> copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: selectedMessages[0].message)).then((value){
      selectedMessages.clear();
      CustomToast(context: context, message: "Text Copied");
      notifyListeners();
    }).onError((error, stackTrace){

    });
  }



}
