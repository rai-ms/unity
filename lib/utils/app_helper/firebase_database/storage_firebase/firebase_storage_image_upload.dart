import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseImageUpload {
  Future<String> uploadProfileImageFile(File? pickedImage) async {
    String timeid = DateTime.now().microsecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref('/profile_pic/' + timeid);
    UploadTask task = ref.putFile(pickedImage!.absolute);
    await Future.value(task);
    String imUrl = await ref.getDownloadURL();
    debugPrint("Profile Image url is"+imUrl);
    return imUrl;
  }
  Future<String> uploadProfileImageLink(String imUrl) async {
    return imUrl;
  }

}
