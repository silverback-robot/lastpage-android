import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/new_group.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({required this.info, Key? key}) : super(key: key);

  final UserGroup info;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(info.groupName),
      subtitle: Text(
          info.subjectGroup
              ? "${info.subjectCode} | ${info.subjectTitle}"
              : "Generic group",
          overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () =>
          Navigator.pushNamed(context, '/group_activity', arguments: info),
    );
  }
}
