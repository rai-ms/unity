import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:unity/global/global.dart';
import 'package:unity/res/components/app_rounded_button.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_image.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/utils/routes/route_name.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});
  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  int pos = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              pos = index;
              setState(() {});
            },
            controller: PageController(
                initialPage: 0, keepPage: false, viewportFraction: 1),
            pageSnapping: true,
            reverse: false,
            allowImplicitScrolling: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Center(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.blueSplashScreen,
                  ),
                  child: Column(
                    children: [
                      sizedBox(hei: 50),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Text(
                          "Get Closer To EveryOne",
                          style: AppStyle.blackNormal36,
                        ),
                      ),
                      Text(
                        "Helps you to contact everyone with just easy way",
                        style: AppStyle.blackNormal15,
                      ),
                      Image.asset(AppImages.introPeople),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.blueSplashScreen,
                  ),
                  child: Column(
                    children: [
                      sizedBox(hei: 50),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Text(
                          "Get Closer To EveryOne",
                          style: AppStyle.blackNormal36,
                        ),
                      ),
                      Text(
                        "Helps you to contact everyone with just easy way",
                        style: AppStyle.blackNormal15,
                      ),
                      Image.asset(AppImages.introPeople),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.blueSplashScreen,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          sizedBox(hei: 50),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Text(
                              "Get Closer To EveryOne",
                              style: AppStyle.blackNormal36,
                            ),
                          ),
                          Text(
                            "Helps you to contact everyone with just easy way",
                            style: AppStyle.blackNormal15,
                          ),
                          Image.asset(AppImages.introPeople),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 78.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AppRoundedButton(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RouteName.loginView, (route) => false);
                            },
                            title: "Get Start",
                            buttonColor: AppColors.white,
                            textColor: AppColors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: DotsIndicator(
                dotsCount: 3,
                position: pos,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(25.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
