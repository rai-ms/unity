import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/utils/routes/route_name.dart';
import 'package:unity/view_model/chat_view_model/chat_view_model.dart';
import 'package:unity/view_model/home_view_model/home_view_model.dart';
import '../../model/firebase/message_model.dart';

class ForwardMessageView extends StatefulWidget {
  const ForwardMessageView({super.key, required this.messagesList, required this.receiverData});
  final List<MessageModel> messagesList;
  final UserProfileModel receiverData;
  @override
  State<ForwardMessageView> createState() => _ForwardMessageViewState();
}

class _ForwardMessageViewState extends State<ForwardMessageView> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:
        [
          ChangeNotifierProvider(create: (context)=> HomeViewModel()),
          ChangeNotifierProvider(create: (context)=> ChatViewModel()),
        ],
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Consumer<HomeViewModel>(builder: (context, provider, child){
                return StreamBuilder<List<UserProfileModel>>(stream: provider.getAllUser(), builder: (context,AsyncSnapshot<List<UserProfileModel>> snapshot)
                {
                  List<UserProfileModel>? users =  snapshot.data;

                  if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else
                  {
                    return ListView.builder(itemBuilder: (context, index) {
                      return Consumer<ChatViewModel>(
                        builder: (context, providerChat, child) {
                          return ListTile(
                            onTap: (){
                              providerChat.forwardMessage(widget.messagesList, users[index].uid);
                              Future.delayed(const Duration(seconds: 1));
                              Navigator.pushNamedAndRemoveUntil(context, RouteName.chatView, arguments: {"user": widget.receiverData},(route) => route.isFirst);
                            },
                            leading: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: users[index].image,
                              ),
                            ),
                            title: Text(users[index].name),
                          );
                        }
                      );
                    }, itemCount: users!.length,);
                  }
                });
              },),
            ),
          ],
        ),
      ),);
  }
}
