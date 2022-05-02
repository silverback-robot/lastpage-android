import 'package:flutter/material.dart';
import 'package:lastpage/models/new_group.dart';
import 'package:lastpage/widgets/groups/group_activity/action_button.dart';
import 'package:lastpage/widgets/groups/group_activity/expandable_fab.dart';

class GroupActivity extends StatelessWidget {
  const GroupActivity({Key? key}) : super(key: key);

  static const _actionTitles = [
    'Post a message',
    'Share Notes',
    'Invite Friends'
  ];

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserGroup;
    return Scaffold(
      body: Center(
        child: Text(args.groupName),
      ),
      floatingActionButton: ExpandableFAB(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.format_size),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }
}
