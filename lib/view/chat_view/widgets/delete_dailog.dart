import 'package:flutter/material.dart';
import 'package:unity/utils/app_helper/app_strings.dart';
class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key, this.isDeleteForAll = false, this.deleteForAll, this.deleteForMe});
  final bool isDeleteForAll;
  final VoidCallback? deleteForMe, deleteForAll;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.deleteMessage),
      actions:
      [
        InkWell(
            onTap:(){
              deleteForMe!();
              Navigator.pop(context);
            },
            child: const Text(AppStrings.deleteForMe)),
        if(isDeleteForAll) InkWell(
            onTap: (){
              deleteForAll!();
              Navigator.pop(context);
            },
            child: const Text(AppStrings.deleteForAll))
      ],
    );
  }
}
