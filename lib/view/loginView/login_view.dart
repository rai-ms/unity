import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unity/global/global.dart';
import 'package:unity/res/components/app_rounded_button.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/utils/routes/route_name.dart';
import '../../utils/app_helper/app_strings.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final databaseRef = FirebaseDatabase.instance.ref("Group_Chat");
  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedBox(hei: 50),
                Text(AppStrings.login, style: AppStyle.blueBold20,),
                sizedBox(hei: 20),
                TextFormField(
                  // controller: provider.passCont,
                  // focusNode: provider.passFocusNode,
                  // validator: Utils.isValidPass,
                  onFieldSubmitted: (_) {
                    // Utils.changeFocus(context, provider.passFocusNode, provider.loginButtonFocusNode);
                  },
                  obscuringCharacter: "*",
                  // obscureText: provider.obsText,
                  decoration:  const InputDecoration(
                    // suffixIcon: InkWell(
                    //     onTap: (){
                    //       // provider.passShowHide();
                    //     },
                    //     child: Icon(provider.obsText ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                          BorderSide(width: 2, color: AppColors.black)),
                      hintText: AppStrings.enterEmailAddress,
                      label: Text(AppStrings.yourEmail),
                      constraints: BoxConstraints(
                        maxWidth: 400,
                      ),
                      hoverColor: AppColors.blueAccent),
                ),
                sizedBox(hei: 20),
                TextFormField(
                  // controller: provider.passCont,
                  // focusNode: provider.passFocusNode,
                  // validator: Utils.isValidPass,
                  onFieldSubmitted: (_) {
                    // Utils.changeFocus(context, provider.passFocusNode, provider.loginButtonFocusNode);
                  },
                  obscuringCharacter: "*",
                  // obscureText: provider.obsText,
                  decoration:  const InputDecoration(
                    // suffixIcon: InkWell(
                    //     onTap: (){
                    //       // provider.passShowHide();
                    //     },
                    //     child: Icon(provider.obsText ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                          BorderSide(width: 2, color: AppColors.black)),
                      hintText: AppStrings.password,
                      label: Text(AppStrings.password),
                      constraints: BoxConstraints(
                        maxWidth: 400,
                      ),
                      hoverColor: AppColors.blueAccent),
                ),
                sizedBox(hei: 20),
                AppRoundedButton(onTap: (){}, title: AppStrings.login,buttonColor: AppColors.blueSplashScreen,textColor: AppColors.white,),
                sizedBox(hei: 20),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, RouteName.signupView);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: AppStyle.blackBold16,
                      children: const <TextSpan>[
                        TextSpan(text:  AppStrings.dontHaveAccount,),
                        TextSpan(text: AppStrings.signUp, style: TextStyle(
                          color: AppColors.blue,
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
