import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/res/components/custom_toast.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/utils/routes/route_name.dart';

import '../../../utils/app_helper/app_color.dart';
import '../../../utils/app_helper/firebase_database/fireStore/user_profile_fireStore/users_profile_fireStore.dart';
import '../../../view_model/home_view_model/home_view_model.dart';

class UserProfileDialog extends StatefulWidget {
  const UserProfileDialog({super.key, required this.user});
  final UserProfileModel user;

  @override
  State<UserProfileDialog> createState() => _UserProfileDialogState();
}

class _UserProfileDialogState extends State<UserProfileDialog> {

  @override
  void dispose() {
    HomeViewModel.setUserStatus(DateTime.now().toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 404
      ),
      child: Column(
        children:
        [
          Stack(
            children: [
              Center(
                child: SizedBox(
                    height: 350,
                    width: 350,
                    child: CachedNetworkImage(imageUrl: widget.user.image, fit: BoxFit.fill,)),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: const BoxDecoration(
                      color: AppColors.fadeBlack
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      Text(widget.user.name, style: AppStyle.whiteMedium22,)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
              decoration: const BoxDecoration(
                color: AppColors.blueSplashScreen
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    InkWell(
                        onTap: ()
                        {
                          Navigator.pushNamedAndRemoveUntil(context, RouteName.chatView, arguments: {"user":widget.user}, (route)=> route.isFirst);
                          // Navigator.pushNamed(context, RouteName.chatView, arguments: {"user":user});
                        },
                        child: const Icon(Icons.message_outlined, color: AppColors.white,)),
                    InkWell(
                        onTap: ()
                        {
                          // ThirdUserInfoView
                          Navigator.pushNamedAndRemoveUntil(context, RouteName.thirdUserInfoView, arguments: {"user":widget.user}, (route)=> route.isFirst);

                        },
                        child: const Icon(Icons.info_outline_rounded, color: AppColors.white,)),
                    InkWell(
                        onTap: ()
                        {
                          UsersProfileFireStore.blockUser(widget.user.uid);
                          Navigator.pop(context);
                          CustomToast(context: context, message: "User Blocked");
                        },
                        child: const Icon(Icons.warning_amber, color: AppColors.white,)),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
