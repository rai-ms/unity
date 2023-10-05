import 'package:flutter/material.dart';

import '../../global/global.dart';
import '../../services/splashscreen_service.dart';
import '../../utils/app_helper/app_color.dart';
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
      body: Container(
        decoration: const BoxDecoration(
            color: AppColors.blueSplashScreen
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Unity", style: AppStyle.whiteBold30,),
              sizedBox(hei: 20),
              const Icon(Icons.chat_outlined, color: AppColors.white,),
              sizedBox(hei: 20),
              const SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
