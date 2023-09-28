import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unity/res/components/custom_toast.dart';
import 'package:unity/utils/routes/route_name.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController mailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode buttonFocusNode = FocusNode();
  GlobalKey formkey = GlobalKey();



  bool _obsText = false;
  bool get obsText => _obsText;
  passShowHide()
  {
    _obsText = !_obsText;
    notifyListeners();
  }


  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }



  login(context) {
    setLoading(true);
    _auth
        .signInWithEmailAndPassword(
            email: mailCont.text.toString().trim(),
            password: passCont.text.toString().trim())
        .then((value) {
      setLoading(false);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.homeView, (route) => false);
    }).onError((error, stackTrace) {
      setLoading(false);
      CustomToast(context: context, message: "Wrong Credentials");
    });
  }
}
