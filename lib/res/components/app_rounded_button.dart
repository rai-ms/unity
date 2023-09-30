import 'package:flutter/material.dart';

import '../../utils/app_helper/app_color.dart';
import '../../utils/app_helper/app_style.dart';

class AppRoundedButton extends StatelessWidget {
  String title;
  VoidCallback onTap;
  bool loading;
  FocusNode? focusNode;
  Color? buttonColor = AppColors.blueSplashScreen;
  Color? textColor = AppColors.white;

  AppRoundedButton(
      {super.key,
      this.buttonColor,
      required this.onTap,
      required this.title,
      this.textColor,
      this.focusNode,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusNode: focusNode,
      child: Container(
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: loading
                ? const CircularProgressIndicator(
                    color: AppColors.white,
                  )
                : Text(
                    title,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400),
                  )),
      ),
    );
  }
}
