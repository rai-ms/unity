import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/app_helper/app_color.dart';

Widget userProfileImageInCircle(String image){
  return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          border: Border.all(color: AppColors.blueSplashScreen, width: 5)
      ),
      child: ClipOval(child: CachedNetworkImage(imageUrl: image, fit: BoxFit.fill,)));
}