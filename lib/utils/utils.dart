import 'package:flutter/material.dart';

class Utils {
  static changeFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static String? isValidEmail(String? email) {
     if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email!))
     {
       return null;
     }
     else
     {
       return "Enter Valid Mail";
     }
  }

  static String? isValidPass(String? value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  static String? isValidName(String? value) {
    if(value!.isEmpty){
      return 'Enter Your Name';
    }
    else if(value.length < 3) {
      return 'Enter a Valid Name';
    }
    return null;
  }

  static hideKeyboard(context){
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

}
