import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/new_group.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({required this.info, Key? key}) : super(key: key);

  final UserGroup info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10),
      child: ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(info.groupName),
        subtitle: Text(
            info.subjectGroup
                ? "${info.subjectCode} | ${info.subjectTitle}"
                : "Generic group",
            overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () =>
            Navigator.pushNamed(context, '/group_activity', arguments: info),
      ),
    );
  }
}
