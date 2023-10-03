import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/global/global.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/utils/routes/route_name.dart';
import 'package:unity/view/chat_view/widgets/chat_info_dialog.dart';
import 'package:unity/view_model/chat_view_model/chat_view_model.dart';
import '../../model/firebase/user_profile_model.dart';
import '../../utils/app_helper/app_strings.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.receiverData});
  final UserProfileModel receiverData;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:
      [
        ChangeNotifierProvider(create: (context) => ChatViewModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<ChatViewModel>(
            builder: (context, provider, child) {
              return provider.selectedMessages.isEmpty? Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.blueSplashScreen, width: 2.0,),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.receiverData.image,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  sizedBox(wid: 20),
                  Text(widget.receiverData.name),
                  Consumer<ChatViewModel>(
                    builder: (context, provider, child)
                    {
                      return StreamBuilder(
                          stream: provider.getStatus(widget.receiverData.uid),
                          builder: (context,isActive){
                        if(!isActive.hasData || isActive.connectionState == ConnectionState.waiting) return const SizedBox();
                          return Icon(Icons.circle, color: provider.isOnline? AppColors.green:AppColors.grey,);
                      });
                  }),
                  // Icon(Icons.circle, color: widget.receiverData.onLineStatus == 1? AppColors.green : AppColors.grey,)
                ],
              ) :
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: ()
                      {

                      },
                      child: const Icon(Icons.delete, size: 35,)),
                  const SizedBox(width: 20,),
                  InkWell(
                      onTap: (){
                          Navigator.pushNamed(context, RouteName.forwardMessageView, arguments: {"messagesList" :provider.selectedMessages, "receiverData":widget.receiverData});
                      },
                      child: const Icon(Icons.forward, size: 35,)),
                  const SizedBox(width: 10,),
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
                child:
                  Consumer<ChatViewModel>(builder: (context, provider, child)
                    {
                      return StreamBuilder<List<MessageModel>>(
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
                            itemBuilder: (context, index)
                            {
                              bool isSender = messages[index].senderUID == provider.auth.currentUser!.uid;
                              bool isImage = messages[index].img != null && messages[index].img != "";
                              String image = messages[index].img ?? "";
                              if (messages[index].visibleNo != 0) {
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
                                                showDialog(context: context, builder: (context)=>Dialog(child: ChatInfoDialog(messageModel: messages[index],),));
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
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              messages[index] .time.substring(11, 16),
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
      ),
    );
  }
}
