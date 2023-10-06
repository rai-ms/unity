import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unity/res/components/custom_toast.dart';
import 'package:unity/utils/routes/route_name.dart';

import '../home_view_model/home_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController mailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode buttonFocusNode = FocusNode();
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  void dispose() {
    mailCont.dispose();
    passFocusNode.dispose();
    passCont.dispose();
    emailFocusNode.dispose();
    formkey.currentState!.dispose();
    buttonFocusNode.dispose();

    super.dispose();
  }

  bool _obsText = false;
  bool get obsText => _obsText;
  passShowHide() {
    _obsText = !_obsText;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }



  login(BuildContext context) async {
    formkey.currentState!.save();
    if(formkey.currentState!.validate()){
      setLoading(true);
      try {
        await _auth.signInWithEmailAndPassword(
          email: mailCont.text.toString().trim(),
          password: passCont.text.toString().trim(),
        );

        setLoading(false);

        if(context.mounted)
        {
          HomeViewModel.setUserStatus("true");
          Navigator.pushNamedAndRemoveUntil(
            context, RouteName.homeView, (route) => false,
          );
        }
      } catch (error) {
        setLoading(false);
        if (error is SocketException) {
          // Handle SocketException (when data is off)
          if(context.mounted)
          {
            CustomToast(context: context, message: "Data is Off");
          }
        } else {
          if(context.mounted)
          {
            CustomToast(context: context, message: "Wrong Credentials");
          }
        }
      }
    }
  }

}
