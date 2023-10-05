import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/global/global.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/res/components/custom_toast.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/utils/app_helper/firebase_database/fireStore/user_profile_fireStore/users_profile_fireStore.dart';
import 'package:unity/utils/routes/route_name.dart';
import 'package:unity/view_model/third_user_view_model/third_user_view_model.dart';
import '../../res/components/user_profile_circle_image.dart';
import '../../utils/app_helper/app_color.dart';

class ThirdUserInfoView extends StatefulWidget {
  const ThirdUserInfoView({super.key, required this.thirdUser});
  final UserProfileModel thirdUser;
  @override
  State<ThirdUserInfoView> createState() => _ThirdUserInfoViewState();
}

class _ThirdUserInfoViewState extends State<ThirdUserInfoView> {

  List<MessageModel>? images = [];
  @override
  void initState(){
    super.initState();
    ThirdUserViewModel.thirdUser = widget.thirdUser;
    loadImages();
  }

  void loadImages() async {
    // images = await ThirdUserViewModel().getAllImages();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [ChangeNotifierProvider(create: (context)=>ThirdUserViewModel())],
    child: Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              userProfileImageInCircle(widget.thirdUser.image),
              sizedBox(hei: 20),
              Text(widget.thirdUser.name, style: AppStyle.blackBold34,),
              Text(widget.thirdUser.email, style: AppStyle.blackMedium16,),
              sizedBox(hei: 20),
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.fadeBlack
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, RouteName.chatView, arguments: {"user":widget.thirdUser});
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.chat_outlined, color: AppColors.blueSplashScreen,size: 40,),
                            Text("Message", style: AppStyle.blueSplashBold20,)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          CustomToast(context: context, message:  "User is Blocked");
                          UsersProfileFireStore.blockUser(widget.thirdUser.uid);
                          Navigator.pushNamedAndRemoveUntil(context, RouteName.homeView, (route) => false);
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.warning_amber, color: AppColors.blueSplashScreen,size: 40,),
                            Text("Block User", style: AppStyle.blueSplashBold20,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Join Date:${widget.thirdUser.joinDate}",textAlign: TextAlign.start,style: AppStyle.blackNormal20,),
                  ],
                ),
              ),
              Container(
                height: 105,
                decoration: const BoxDecoration(
                  color: AppColors.grey,
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,top: 10),
                      child: Text("Images",style: AppStyle.blackBold24,),
                    ),
                    // SizedBox(
                    //   height: 60,
                    //   child: Consumer<ThirdUserViewModel>(
                    //     builder: (context, provider, child) {
                    //       StreamBuilder(
                    //         stream: provider.getAllImages(),
                    //         builder: (context,AsyncSnapshot<List<MessageModel>> imagesList){
                    //           // debugPrint(imagesList.length.toString());
                    //           List<MessageModel>? images = imagesList.data;
                    //
                    //           debugPrint(images!.length.toString());
                    //
                    //           if(!imagesList.hasData || imagesList.connectionState == ConnectionState.waiting){
                    //             return const Center(child: CircularProgressIndicator());
                    //           }
                    //           return ListView.builder(
                    //             scrollDirection: Axis.horizontal,
                    //             shrinkWrap: true,
                    //             itemBuilder: (context, index) {
                    //               return Container(
                    //                 padding: const EdgeInsets.all(10),
                    //                 decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(20),
                    //                 ),
                    //                 child: const Center(
                    //                     child: Text("Images"),
                    //                     // CachedNetworkImage(
                    //                     //   imageUrl: imagesList.data![index].img ?? "",
                    //                     // )
                    //                 ),
                    //               );
                    //             },
                    //             itemCount: imagesList.data!.length,
                    //           );
                    //         },
                    //       );
                    //       if(images!.isEmpty){
                    //         return Text("No Image Found! ${images!.length}");
                    //       }
                    //       else {
                    //         return Container();
                    //       }
                    //     }
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}