import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/group_activity.dart';

class DisplayMessage extends StatelessWidget {
  const DisplayMessage({required this.groupActivity, Key? key})
      : super(key: key);
  final GroupActivity groupActivity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: Text(groupActivity.messagePublishText!,
          style: const TextStyle(fontSize: 18)),
    );
  }
}
