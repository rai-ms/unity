import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unity/view_model/signup_view_model/signup_view_model.dart';
import '../../global/global.dart';
import 'package:provider/provider.dart';
import '../../res/components/app_rounded_button.dart';
import '../../utils/app_helper/app_color.dart';
import '../../utils/app_helper/app_strings.dart';
import '../../utils/app_helper/app_style.dart';
import '../../utils/utils.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:
      [
        ChangeNotifierProvider(create: (context) => SignUpViewModel()),
      ],
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Consumer<SignUpViewModel>(builder: (context, provider, child){
              return Form(
                key: provider.formKey,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    sizedBox(hei: 50),
                    Text(AppStrings.createAnAccount, style: AppStyle.blueBold20,),
                    sizedBox(hei: 20),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: null,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: InkWell(
                                    onTap: (){
                                      
                                    },
                                    child: const Icon(Icons.camera_alt_outlined, color: AppColors.blueAccent,size: 25,)),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    sizedBox(hei: 20),
                    TextFormField(
                      controller: provider.nameCont,
                      focusNode: provider.nameFocusNode,
                      validator: Utils.isValidName,
                      onFieldSubmitted: (_) {
                        provider.emailFieldSubmitted(context);
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide:
                              BorderSide(width: 2, color: AppColors.black)),
                          hintText: AppStrings.yourName,
                          label: Text(AppStrings.fullName),
                          constraints: BoxConstraints(
                            maxWidth: 400,
                          ),
                          hoverColor: AppColors.blueAccent),
                    ),
                    sizedBox(hei: 20),
                    TextFormField(
                      controller: provider.emailCont,
                      focusNode: provider.emailFocusNode,
                      validator: Utils.isValidEmail,
                      onFieldSubmitted: (_) {
                        Utils.changeFocus(context, provider.emailFocusNode, provider.passFocusNode);
                      },
                      decoration:  const InputDecoration(
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
                      controller: provider.passCont,
                      focusNode: provider.passFocusNode,
                      validator: Utils.isValidPass,
                      onFieldSubmitted: (_) {
                        Utils.changeFocus(context, provider.passFocusNode, provider.confPassFocusNode);
                      },
                      obscuringCharacter: "*",
                      obscureText: provider.obsText,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                            onTap: (){
                              provider.passShowHide();
                            },
                            child: Icon(provider.obsText ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide:
                              BorderSide(width: 2, color: AppColors.black)),
                          hintText: AppStrings.password,
                          label: const Text(AppStrings.password),
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          hoverColor: AppColors.blueAccent),
                    ),
                    sizedBox(hei: 20),
                    TextFormField(
                      controller: provider.confPassCont,
                      focusNode: provider.confPassFocusNode,
                      validator: Utils.isValidPass,
                      onFieldSubmitted: (_) {
                        Utils.changeFocus(context, provider.confPassFocusNode, provider.loginButtonFocusNode);
                      },
                      obscuringCharacter: "*",
                      obscureText: provider.obsText,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                            onTap: (){
                              provider.passShowHide();
                            },
                            child: Icon(provider.obsText ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide:
                              BorderSide(width: 2, color: AppColors.black)),
                          hintText: AppStrings.confirmPassword,
                          label: const Text(AppStrings.reEnterPassword),
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          hoverColor: AppColors.blueAccent),
                    ),
                    sizedBox(hei: 20),
                    AppRoundedButton(
                      loading: provider.loading,
                      focusNode: provider.loginButtonFocusNode,
                      onTap: ()
                      {
                          provider.createAccount(context);
                      },
                      title: AppStrings.createAccount,buttonColor: AppColors.blueSplashScreen,textColor: AppColors.white,)
                  ],
                ),
              );
            },),
          ),
        )
    ),);
  }
}
