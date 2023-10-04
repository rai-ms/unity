import 'package:flutter/material.dart';
import 'app_color.dart';

class AppStyle {
  // Bold, 16, whiteBold

  static TextStyle? get whiteBold16 {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get whiteBold30 {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 30,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get blackBold16 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get yellowBold16 {
    return const TextStyle(
      color: AppColors.yellow,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get blackBold24 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get blackBold34 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 32,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get blackBold20 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get blueSplashBold20 {
    return const TextStyle(
      color: AppColors.blueSplashScreen,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get greyRegular20 {
    return const TextStyle(
      color: AppColors.grey,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle? get blackMedium16 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle? get blackNormal20 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle? get whiteMedium16 {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle? get whiteMedium10 {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 8,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle? get chatStyle {
    return const TextStyle(
      color: AppColors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  // Bold, 14, grey Medium
  static TextStyle? get greyMedium14 {
    return const TextStyle(
      color: AppColors.grey,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle? get blueBold30 {
    return const TextStyle(
      color: AppColors.blue,
      fontSize: 30,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? get blueBold20 {
    return const TextStyle(
      color: AppColors.blue,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle get blueNormal {
    return const TextStyle(
      color: AppColors.blue,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle get blackSmall12 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle get blueItalicBold15 {
    return const TextStyle(
      color: AppColors.blueSplashScreen,
      fontSize: 15,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle get blackNormal36 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 36,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle get blackNormal15 {
    return const TextStyle(
      color: AppColors.black,
      fontSize: 15,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
    );
  }
}
