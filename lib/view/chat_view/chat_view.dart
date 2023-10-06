import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/global/global.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/utils/routes/route_name.dart';
import 'package:unity/view/chat_view/widgets/chat_info_dialog.dart';
import 'package:unity/view/chat_view/widgets/delete_dailog.dart';
import 'package:unity/view_model/chat_view_model/chat_view_model.dart';
import '../../model/firebase/user_profile_model.dart';
import '../../utils/app_helper/app_strings.dart';
import '../../utils/app_helper/firebase_database/fireStore/user_profile_fireStore/users_profile_fireStore.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.receiverData});
  final UserProfileModel receiverData;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blueSplashScreen,
        title: Consumer<ChatViewModel>(
            builder: (context, provider, child)
            {
              return provider.selectedMessages.isEmpty? InkWell(
                onTap: (){
                  Navigator.pushNamedAndRemoveUntil(context, RouteName.thirdUserInfoView, arguments: {"user" : widget.receiverData}, (route)=> route.isFirst);
                },
                child: Row(
                  children: [
                    InkWell(
                        onTap: ()
                        {
                            Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back, color: AppColors.white,)),
                    sizedBox(wid: 20),
                    Hero(
                      tag: "Profile",
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 1.0,),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.receiverData.image,
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                    sizedBox(wid: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.receiverData.name, style: AppStyle.whiteMedium22,),
                        StreamBuilder(
                            stream: provider.getStatus(widget.receiverData.uid),
                            builder: (context,isActive){
                              if(!isActive.hasData || isActive.connectionState == ConnectionState.waiting) return const SizedBox();
                              return provider.isOnline? Row(
                                children: [
                                  const Icon(Icons.circle, color:AppColors.green,),
                                  Text("Online",style: AppStyle.whiteMedium16,),
                                ],
                              ) : Text("Last seen: ${UsersProfileFireStore.offlineTime.substring(11, 16)}", style: AppStyle.whiteMedium16,);
                            }),
                      ],
                    ),
                    sizedBox(wid: 20),
                    // Icon(Icons.circle, color: widget.receiverData.onLineStatus == 1? AppColors.green : AppColors.grey,)
                  ],
                ),
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: (){
                        provider.removeAllFromList();
                      },
                  child: const Icon(Icons.arrow_back, color: AppColors.white,)),
                  Row(
                   children: [
                     if(provider.selectedMessages.length == 1)
                       Row(
                         children: [
                           if(provider.isAvailableToStar()) InkWell(onTap:(){
                             provider.toggleStar();
                           },
                               child: const Icon(Icons.star, color: AppColors.white,)),
                           const SizedBox(width: 20,),
                           InkWell(onTap:(){
                             provider.copyToClipboard(context);
                           },
                               child: const Icon(Icons.copy, color: AppColors.white,)),
                         ],
                       ),
                     const SizedBox(width: 20,),
                     InkWell(
                         onTap: ()
                         {
                           bool deleteAll = provider.isAvailableToDeleteForAll();
                            showDialog(context: context, builder: (context)=> DeleteDialog(deleteForMe: provider.deleteForMe,deleteForAll: provider.deleteForAll,isDeleteForAll:deleteAll ,));
                             // provider.deleteMessages();
                         },
                         child: const Icon(Icons.delete, size: 35, color: AppColors.white,)),
                     const SizedBox(width: 20,),
                     InkWell(
                         onTap: (){

                           Navigator.pushNamed(context, RouteName.forwardMessageView, arguments: {"messagesList" :provider.selectedMessages, "receiverData":widget.receiverData},);
                         },
                         child: const Icon(Icons.forward, size: 35, color: AppColors.white,)),
                     const SizedBox(width: 10,),
                   ],
                 )
                ],
              );
            }
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child:Consumer<ChatViewModel>(builder: (context, provider, child)
              {
                return StreamBuilder<List<MessageModel>> (
                    stream: provider.getAllMessage(widget.receiverData.uid),
                    builder: (context, AsyncSnapshot<List<MessageModel>> snapshot)
                    {
                      List<MessageModel>? messages = snapshot.data;
                      if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
                      {
                        return const Center(child: CircularProgressIndicator());
                      }
                      else if (snapshot.hasError)
                      {
                        return const Center(
                          child: Text(AppStrings.error),
                        );
                      }
                      else
                      {
                        return ListView.builder(
                          reverse: true,
                          itemBuilder: (context, indexx)
                          {
                            int size = messages.length;
                            int index = size-indexx-1;
                            bool isSender = messages[index].senderUID == provider.auth.currentUser!.uid;
                            bool isImage = messages[index].img != null && messages[index].img != "";
                            String image = messages[index].img ?? "";
                            if (messages[index].visibleNo != 0 && ((isSender && messages[index].visibleNo != 1) || (!isSender && messages[index].visibleNo != 2))) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !(provider.isContains(messages[index]) == -1)? AppColors.green:null,
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: isSender
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: isSender? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              // debugPrint("DeleteMessage");
                                              // provider.deleteMessage(
                                              //     messages[index], 0);
                                              provider.toggleMessage(messages[index]);
                                            },
                                            onDoubleTap: () {},
                                            onLongPress: (){
                                               showDialog(context: context, builder: (context)=>Dialog(child: ChatInfoDialog(messageModel: messages[index],context: context,),));
                                              // showDialog(context: context, builder: (context) => Dialog(
                                              //   child: Text("Hii"),
                                              // ));
                                            },
                                            child: Card(
                                              child: Container(
                                                padding:const EdgeInsets.all(10),
                                                constraints:const BoxConstraints(maxWidth: 270),
                                                decoration: BoxDecoration(gradient: LinearGradient(colors:
                                                !isSender?[ AppColors.blueSplashScreen, AppColors.blueAccent] : [AppColors.blueAccent, AppColors.blueSplashScreen],), borderRadius: BorderRadius.circular(10)),
                                                child: Column(
                                                  crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                  children: [
                                                    if(messages[index].star == 1) const Icon(Icons.star, color: AppColors.white,),
                                                    if(messages[index].isForwarded != 0) SizedBox(
                                                      width: 100,
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.forward_outlined, color: AppColors.white,),
                                                          Text((messages[index].isForwarded == 1) ? AppStrings.forwarded : AppStrings.multiForwarded, style: AppStyle.whiteMedium16,)
                                                        ],),
                                                    ),
                                                    if (isImage) Container(
                                                      padding: const EdgeInsets.all(4),
                                                      decoration: const BoxDecoration(
                                                        color: AppColors.blueSplashScreen,
                                                      ),
                                                      child: CachedNetworkImage(imageUrl: image,),
                                                    )
                                                    else Text(
                                                      messages[index].message,
                                                      style: AppStyle.chatStyle,
                                                    ),
                                                    if (isSender) Icon(
                                                      messages[index].status == 0
                                                          ? Icons
                                                          .check
                                                          : Icons.done_all,
                                                      color: messages[index].status == 2 ? AppColors.yellow :AppColors.grey,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            messages[index].time.substring(11, 16),
                                            style: AppStyle.blackNormal15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                          itemCount: messages!.length,
                        );
                      }
                    });
              }),
            ),
            Consumer<ChatViewModel>(builder: (context, provider, child) {
              return Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      controller: provider.messCont,
                      focusNode: provider.messFocus,
                      onFieldSubmitted: (_)
                      {
                        provider.sendMessage(widget.receiverData.uid);
                      },
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () async {
                                await provider.pickAndSendImage(widget.receiverData.uid);
                              },
                              child: const Icon(Icons.image, color: AppColors.blueSplashScreen,)),
                          border: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              borderSide:
                              BorderSide(width: 2, color: AppColors.black)),
                          hintText: AppStrings.enterMessage,
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          hoverColor: AppColors.blueAccent),
                    ),
                  ),
                  sizedBox(wid: 5),
                  InkWell(
                    onTap: () {
                      provider.sendMessage(widget.receiverData.uid, isImage: false, imageUrl: "");
                    },
                    child: const CircleAvatar(
                      radius: 35,
                      child: Center(
                          child: Icon(
                            Icons.send,
                            color: AppColors.blueSplashScreen,
                          )),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
