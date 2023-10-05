import 'package:flutter/material.dart';

import '../../global/global.dart';
import '../../services/splashscreen_service.dart';
import '../../utils/app_helper/app_color.dart';
import '../../utils/app_helper/app_strings.dart';
import '../../utils/app_helper/app_style.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    loading();
  }

  Future<void> loading() async {
    await SplashScreenServices.checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
            height: getFullHeight(context),
            width: getFullWidth(context),
            decoration: const BoxDecoration(color: AppColors.blueSplashScreen),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.home_max_outlined,
                  color: AppColors.white,
                  size: 50,
                ),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: LinearProgressIndicator(
                        color: AppColors.white,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
