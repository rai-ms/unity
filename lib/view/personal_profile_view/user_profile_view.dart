import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/global/global.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/res/components/user_profile_circle_image.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_strings.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/view_model/home_view_model/home_view_model.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key, required this.user});
  final UserProfileModel user;
  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context)=> HomeViewModel())],
      child: Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: AppColors.white,)),
        backgroundColor: AppColors.blueSplashScreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
          [
            Text(AppStrings.profile, style: AppStyle.whiteBold30,),
          ],
        ),
        actions: [
          Consumer<HomeViewModel>(
            builder: (context, provider, child) {
              return InkWell(
                  onTap: (){
                      provider.signOut(context);
                  },
                  child: const Icon(Icons.exit_to_app, color: AppColors.white,));
            }
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column (
            children: [
              sizedBox(hei: 30),
              userProfileImageInCircle(widget.user.image.toString()),
              sizedBox(hei: 30),
              ListTile(
                leading:const Icon(Icons.person, color: AppColors.blueSplashScreen,),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: AppStyle.greyRegular20,),
                    Text(widget.user.name.toString(), style: AppStyle.blackBold24,),
                  ],
                ),
                trailing: const Icon(Icons.edit, color: AppColors.blueSplashScreen,),
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
                    Text(widget.user.email.toString(), style: AppStyle.blackNormal20,),
                  ],
                ),
              ),
              sizedBox(hei: 30),
              Text("Blocked Users", style: AppStyle.blackBold24,),
              (widget.user.blockedUID.isNotEmpty) ?
                Column(
                  children: [
                    Text("Find Blocked User's UID's ${widget.user.blockedUID.length} \n         Tap to Unblock"),
                    SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index)=>
                          Consumer<HomeViewModel>(
                            builder: (context, provider, child)
                            {
                              return Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.blueSplashScreen, width: 2),
                                ),
                                child: Text(widget.user.blockedUID[index]),
                              );
                            }
                        ),
                      itemCount: widget.user.blockedUID.length,)
                    ),
                  ],
                ):
                  const Text("No Blocked User Found!")
            ],
          ),
        ),
      ),
    ),
    );
  }
}
