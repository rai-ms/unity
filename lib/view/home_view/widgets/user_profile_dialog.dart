import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/utils/routes/route_name.dart';

import '../../../utils/app_helper/app_color.dart';

class UserProfileDialog extends StatelessWidget {
  const UserProfileDialog({super.key, required this.user});
  final UserProfileModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 405
      ),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                  height: 350,
                  child: CachedNetworkImage(imageUrl: user.image, fit: BoxFit.fill,)),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 20),
                  decoration: const BoxDecoration(
                      color: AppColors.fadeBlack
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      Text(user.name, style: AppStyle.whiteMedium16,)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
              decoration: const BoxDecoration(
                color: AppColors.white
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
                          Navigator.pushNamedAndRemoveUntil(context, RouteName.chatView, arguments: {"user":user}, (route)=> route.isFirst);
                          // Navigator.pushNamed(context, RouteName.chatView, arguments: {"user":user});
                        },
                        child: const Icon(Icons.message_outlined, color: AppColors.blueSplashScreen,)),
                    InkWell(
                        onTap: ()
                        {

                        },
                        child: const Icon(Icons.info_outline_rounded, color: AppColors.blueSplashScreen,)),
                    InkWell(
                        onTap: ()
                        {

                        },
                        child: const Icon(Icons.warning_amber, color: AppColors.blueSplashScreen,)),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
