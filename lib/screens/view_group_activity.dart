import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/all_groups.dart';
import 'package:lastpage/models/groups/new_group.dart';
import 'package:lastpage/models/groups/group_activity.dart' as ga;

import 'package:lastpage/widgets/groups/group_activity/action_button.dart';
import 'package:lastpage/widgets/groups/group_activity/expandable_fab.dart';
import 'package:provider/provider.dart';

class ViewGroupActivity extends StatelessWidget {
  const ViewGroupActivity({Key? key}) : super(key: key);

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
    final groupActivity = Provider.of<AllGroups>(context, listen: false)
        .groupActivity(args.docId!);
    return Scaffold(
      body: StreamBuilder(
        stream: groupActivity,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Oops... Something went wrong!"),
              );
            } else if (snapshot.hasData) {
              List<ga.GroupActivity> allActivity = snapshot.data;
              return allActivity.isNotEmpty
                  ? ListView(
                      children: allActivity
                          .map((e) => Text(e.activityOwner))
                          .toList(),
                    )
                  : const Center(
                      child: Text("No activity here..."),
                    );
            } else {
              return const Center(
                child: Text("No activity here..."),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text(snapshot.connectionState.name),
            );
          }
          return const Center(
            child: Text("No activity here..."),
          );
        },
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
