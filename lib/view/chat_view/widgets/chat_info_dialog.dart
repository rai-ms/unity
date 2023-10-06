import 'package:flutter/material.dart';
import 'package:unity/global/global.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/app_helper/app_style.dart';

class ChatInfoDialog extends StatefulWidget {
  const ChatInfoDialog({super.key, required this.messageModel,required this.context});
  final MessageModel messageModel;
  final BuildContext context;
  @override
  State<ChatInfoDialog> createState() => _ChatInfoDialogState();
}

class _ChatInfoDialogState extends State<ChatInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.blueSplashScreen,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.white, width: 2),
      ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("--Message Info--", style: AppStyle.whiteBold20,textAlign: TextAlign.center,),
          sizedBox(hei: 10),
          Text("Message: ${widget.messageModel.message}", style: AppStyle.whiteMedium16,textAlign: TextAlign.center,),
          Text("Sent Time is: ${widget.messageModel.sentTime.substring(0, 16)}", style: AppStyle.whiteMedium16,textAlign: TextAlign.center,),
          Text("Delivered Time is: ${(widget.messageModel.readTime!.length > 16)? widget.messageModel.deliveredTime.toString().substring(0,16) : "ND"}", style: AppStyle.whiteMedium16,textAlign: TextAlign.center,),
          Text("Read Time is: ${(widget.messageModel.readTime!.length > 16)? widget.messageModel.readTime.toString().substring(0,16) : "NR"}", style: AppStyle.whiteMedium16,textAlign: TextAlign.center,),
          Text("Star: ${widget.messageModel.star == 0 ? "No" : "Yes"}", style: AppStyle.whiteMedium16,textAlign: TextAlign.center,),
          Text("Forwarded: ${widget.messageModel.isForwarded == 0 ? "No" : "Yes"}", style: AppStyle.whiteMedium16,textAlign: TextAlign.center,),
        ],
      )),
    );
  }
}
