import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/global/global.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/view_model/chat_view_model/chat_view_model.dart';

import '../../utils/app_helper/app_strings.dart';
import '../../utils/app_helper/firebase_database/firestore/chat_firestore/users_chat.dart';
import '../../utils/app_helper/firebase_database/firestore/user_profile_firestore/users_profile_firestore.dart';

class ChatView extends StatefulWidget {
  ChatView({super.key,required this.id, required this.reciever, required this.image});
  String id, reciever, image;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> ChatViewModel()),
    ], child: Scaffold(
      appBar: AppBar(
        title: Text(widget.reciever),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Expanded(
            flex: 8,
            child: Consumer<ChatViewModel>(
              builder: (context, provider, child)
              {
                return StreamBuilder<List<MessageModel>>(
                    stream: provider.getAllMessage(widget.id),
                    builder: (context,AsyncSnapshot snapshot)
                    {
                      List<MessageModel> messages = snapshot.data;
                      if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      else if(snapshot.hasError)
                      {
                        return const Center(child: Text("Error"),);
                      }
                      else {
                        if(messages.isEmpty) return const Center(child: CircularProgressIndicator());
                        return ListView.builder(itemBuilder: (context,index){
                          return ListTile(
                            title: Text(messages[index].message ?? "message"),
                            trailing: Text(messages[index].time.substring(11, 16) ?? "Time"),
                          );
                        }, itemCount: messages.length,);
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
                      provider.sendMessage(widget.id);
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
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap:(){
                        provider.sendMessage(widget.id);
                      },
                      child: const CircleAvatar(
                        radius: 35,
                        child: Center(child: Icon(Icons.send, color: AppColors.blueSplashScreen,)),
                      ),
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

// ListView.builder(itemBuilder: (context, index){
// return const SizedBox(
// height: 50,
// child: Card());
// }, itemCount: 20,);