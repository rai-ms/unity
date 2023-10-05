import 'package:flutter/cupertino.dart';
import '../../utils/app_helper/firebase_database/fireStore/user_profile_fireStore/users_profile_fireStore.dart';

class UserProfileViewModel extends ChangeNotifier{

  unBlockUser(String id) async {
    await UsersProfileFireStore.blockUser(id, remove: true);
    notifyListeners();
  }
}