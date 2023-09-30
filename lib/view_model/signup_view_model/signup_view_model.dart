import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unity/data/app_exceptions/app_exception.dart';
import '../../model/firebase/user_profile_model.dart';
import '../../utils/app_helper/firebase_database/firestore/user_profile_firestore/users_profile_firestore.dart';
import '../../utils/app_helper/firebase_database/storage_firebase/firebase_storage_image_upload.dart';
import '../../utils/routes/route_name.dart';
import '../../utils/utils.dart';

class SignUpViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController confPassCont = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode confPassFocusNode = FocusNode();
  FocusNode loginButtonFocusNode = FocusNode();

  bool obsText = false;

  signUp() {
    String email = emailCont.text.toString().trim();
    String pass = passCont.text.toString().trim();
    String name = nameCont.text.toString().trim();
    String image = "";
  }

  passShowHide() {
    obsText = !obsText;
    notifyListeners();
  }

  @override
  void dispose() {
    emailCont.dispose();
    passCont.dispose();
    nameCont.dispose();
    confPassCont.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
    nameFocusNode.dispose();
    confPassFocusNode.dispose();
    loginButtonFocusNode.dispose();
    //formKey.currentState!.dispose();
    super.dispose();
  }

  emailFieldSubmitted(BuildContext context) {
    Utils.changeFocus(context, nameFocusNode, emailFocusNode);
  }

  createAccount(BuildContext context) async {

    setLoading(true);

    String emailUser = emailCont.text.toString().trim();
    String passwordUser = passCont.text.toString().trim();
    String nameUser = nameCont.text.toString().trim();
    String confPassUser = confPassCont.text.toString().trim();
    formKey.currentState!.save();
    // Validate Form
    if (formKey.currentState!.validate() && confPassUser == passwordUser) {
      UsersProfileFireStore unityFireStoreUserProfile = UsersProfileFireStore();

      await unityFireStoreUserProfile
          .createUserAccount(emailUser, passwordUser)
          .then((res) async {
        if (res is! UnableToLogin) {
          // Account creation is now done, now to register user need to login with user credential, then fetch uid for reg
          // debugPrint("Account Creation done now login");
          /// No need to login after the creation of account user already login
          // bool login = await unityFireStoreUserProfile.loginUser(emailUser, passwordUser);
          // Now we have UID, so we can upload image on db
          await uploadImage();
          String uid = _auth.currentUser!.uid;
          DateTime now = DateTime.now();
          String date = DateTime(now.year, now.month, now.day)
              .toString()
              .replaceAll("00:00:00.000", "");
          // User added/registered on this date
          // debugPrint(date);
          UserProfileModel userProfileModel = UserProfileModel(
              pass: passCont.text.toString().trim(),
              email: emailCont.text.toString().trim(),
              joinDate: date,
              image: _imgUrl,
              name: nameCont.text.toString().trim(),
              uid: uid);
          unityFireStoreUserProfile
              .registerUser(userProfileModel)
              .then((value) {
            // debugPrint("Registration Success");
            setLoading(false);
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.homeView, (route) => false);
          }).onError((error, stackTrace) {
            debugPrint("Error in registration in View Model \nError:$error");
            setLoading(false);
          });
        } else {
          debugPrint("Error in createUserAccount in View Model $res");
          setLoading(false);
        }
      }).onError((error, stackTrace) {});
    } else if (passCont.text.toString().trim() !=
        confPassCont.text.toString().trim()) {
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password and Confirm Password is not same"),
      ));
    } else {
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Account Creation Failed, fill each and every thing correctly"),
      ));
    }
  }

  bool isPicked = false;
  File? pickedImage;
  String _imgUrl =
      "https://i.pinimg.com/750x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg";
  String get imgurl => _imgUrl;
  fetchImage() async {
    try {
      XFile? pickImage = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxHeight: 200, maxWidth: 300);

      if (pickImage == null) return;
      final tmpImage = File(pickImage.path);
      pickedImage = tmpImage;
      isPicked = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.camera.request();
    // Check the permission status
    if (status.isGranted) {
      debugPrint("Going to fetch Image");
      await fetchImage();
    } else {
      debugPrint("Going to fetch Image in else");
      await fetchImage();
      debugPrint("Image Fetched now going to upload in else");
      // await uploadImage();
      debugPrint("Image Uploaded $_imgUrl in else");
      // openAppSettings();
    }
  }

  Future<void> uploadImage() async {
    if (!isPicked) {
      return debugPrint("Image not Picked");
    } else {
      await FirebaseImageUpload()
          .uploadProfileImageFile(pickedImage)
          .then((value) {
        debugPrint("Image uploaded on db usrl: $value");
        _imgUrl = value;
      }).onError((error, stackTrace) {
        debugPrint("Error during Uploading and getting the url \nError:$error");
      });
    }
  }

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }
}
