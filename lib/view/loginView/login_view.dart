import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/global/global.dart';
import 'package:unity/res/components/app_rounded_button.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/utils/routes/route_name.dart';
import 'package:unity/view_model/login_view_model/login_view_model.dart';
import '../../utils/app_helper/app_strings.dart';
import '../../utils/utils.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> LoginViewModel()),
    ],
      child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Consumer<LoginViewModel>(
                  builder: (context, provider, child) {
                    return Form(
                      key: provider.formkey,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          sizedBox(hei: 50),
                          Text(AppStrings.login, style: AppStyle.blueBold20,),
                          sizedBox(hei: 20),
                          TextFormField(
                            controller: provider.mailCont,
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
                              Utils.changeFocus(context, provider.passFocusNode, provider.buttonFocusNode);
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
                          AppRoundedButton(
                            focusNode: provider.buttonFocusNode,
                            loading: provider.loading,
                            onTap: (){
                              provider.login(context);
                            }, title: AppStrings.login,buttonColor: AppColors.blueSplashScreen,textColor: AppColors.white,),
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
                    );
                  }
              ),
            ),
          )
      ),
    );
  }
}
