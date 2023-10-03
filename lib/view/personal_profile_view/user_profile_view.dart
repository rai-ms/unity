import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unity/global/global.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/res/components/user_profile_circle_image.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_strings.dart';
import 'package:unity/utils/app_helper/app_style.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key, required this.user});
  final UserProfileModel user;
  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueSplashScreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
          [
            Text(AppStrings.profile, style: AppStyle.whiteBold30,),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column (
            children: [
              sizedBox(hei: 30),
              Flexible(
                child: userProfileImageInCircle(widget.user.image.toString()),
              ),
              sizedBox(hei: 30),
              ListTile(
                leading:const Icon(Icons.person, color: AppColors.blueSplashScreen,),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: AppStyle.greyRegular20,),
                    Text(widget.user.name.toString() ?? "", style: AppStyle.blackBold24,),
                  ],
                ),
                trailing: Icon(Icons.edit, color: AppColors.blueSplashScreen,),
              ),
              ListTile(
                leading:const Icon(Icons.info_outline_rounded, color: AppColors.blueSplashScreen,),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("About", style: AppStyle.greyRegular20,),
                    Text("Unity User", style: AppStyle.blackNormal20,),
                  ],
                ),
                trailing: const Icon(Icons.edit, color: AppColors.blueSplashScreen,),
              ),
              ListTile(
                leading:const Icon(Icons.email_outlined, color: AppColors.blueSplashScreen,),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Contact", style: AppStyle.greyRegular20,),
                    Text(widget.user.email.toString() ?? "", style: AppStyle.blackNormal20,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
