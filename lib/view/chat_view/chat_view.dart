import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/global/global.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_style.dart';
import 'package:unity/view_model/chat_view_model/chat_view_model.dart';

import '../../model/firebase/user_profile_model.dart';
import '../../utils/app_helper/app_strings.dart';

class ChatView extends StatefulWidget {
  ChatView({super.key, required this.reciever});
  UserProfileModel reciever;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> ChatViewModel()),
    ], child: Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(widget.reciever.image),
                radius: 20,),
            sizedBox(wid: 20),
            Text(widget.reciever.name),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, provider, child)
              {
                return StreamBuilder <List<MessageModel>> (
                    stream: provider.getAllMessage(widget.reciever.uid),
                    builder: (context,AsyncSnapshot<List<MessageModel>> snapshot)
                    {
                      List<MessageModel>? messages = snapshot.data;
                      if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      else if(snapshot.hasError)
                      {
                        return const Center(child: Text("Error"),);
                      }
                      else {
                        return ListView.builder(itemBuilder: (context,index){
                          bool isSender = messages[index].senderUID == _auth.currentUser!.uid;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 200,
                              ),
                              child: Row(
                                mainAxisAlignment:isSender? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:isSender? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children:
                                    [
                                      InkWell(
                                        onTap: ()
                                        {
                                          provider.deleteMessage(messages[index], 0);
                                        },
                                        onDoubleTap: (){},
                                        child: Card(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            constraints: const BoxConstraints(
                                              maxWidth: 270
                                            ),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: !isSender?[AppColors.blueSplashScreen, AppColors.blueAccent]:[AppColors.blueAccent, AppColors.blueSplashScreen],
                                                ),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              crossAxisAlignment: isSender? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                              children: [
                                                Text(messages[index].message, style: AppStyle.chatStyle,),
                                                if(isSender) Icon(messages[index].status == "u"? Icons.check_circle_outline: Icons.check_circle,color: AppColors.yellow,size: 20,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(messages[index].time.substring(11, 16),  style: AppStyle.blackNormal15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, itemCount: messages!.length,);
                      }
                });
              }
            ),
          ),
          Consumer<ChatViewModel>(
            builder: (context, provider, child) {
              return Row(
                children:
                [
                  Expanded(flex: 7, child: TextFormField(
                    controller: provider.messCont,
                    focusNode: provider.messFocus,
                    onFieldSubmitted: (_) {
                      provider.sendMessage(widget.reciever.uid);
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                            BorderSide(width: 2, color: AppColors.black)),
                        hintText: AppStrings.enterMessage,
                        constraints: BoxConstraints(
                          maxWidth: 400,
                        ),
                        hoverColor: AppColors.blueAccent
                    ),
                  ),),
                  sizedBox(wid: 5),
                  InkWell(
                    onTap:(){
                      provider.sendMessage(widget.reciever.uid);
                    },
                    child: const CircleAvatar(
                      radius: 35,
                      child: Center(child: Icon(Icons.send, color: AppColors.blueSplashScreen,)),
                    ),
                  ),
                ],
              );
            }
          )
        ],),
    ),);
  }
}
