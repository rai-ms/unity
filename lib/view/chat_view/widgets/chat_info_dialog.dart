import 'package:flutter/material.dart';
import 'package:unity/model/firebase/message_model.dart';
import 'package:unity/utils/app_helper/app_color.dart';

class ChatInfoDialog extends StatelessWidget {
  const ChatInfoDialog({super.key, required this.messageModel});
  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.blueAccent,
      ),
      constraints: const BoxConstraints(
          maxHeight: 405
      ),
      child: Column(
        children:
        [
          Text("Message: ${messageModel.message}"),
          Text("Status: ${messageModel.status}"),
          Text("ReadTime: ${messageModel.readTime}"),
          Text("DeliveredTime: ${messageModel.deliveredTime}"),
          Text("SentTime: ${messageModel.sentTime}"),
        ],
      ),
    );
  }
}
