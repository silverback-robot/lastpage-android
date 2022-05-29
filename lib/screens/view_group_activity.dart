import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/all_groups.dart';
import 'package:lastpage/models/groups/new_group.dart';
import 'package:lastpage/models/groups/group_activity.dart' as ga;
import 'package:lastpage/models/user_profile.dart';

import 'package:lastpage/widgets/groups/group_activity/action_button.dart';
import 'package:lastpage/widgets/groups/group_activity/add_user.dart';
import 'package:lastpage/widgets/groups/group_activity/expandable_fab.dart';
import 'package:lastpage/widgets/groups/group_activity/display_new_post.dart';
import 'package:lastpage/widgets/groups/group_activity/share_notes_dialog.dart';
import 'package:provider/provider.dart';

class ViewGroupActivity extends StatefulWidget {
  const ViewGroupActivity({Key? key}) : super(key: key);

  @override
  State<ViewGroupActivity> createState() => _ViewGroupActivityState();
}

class _ViewGroupActivityState extends State<ViewGroupActivity> {
  String? publishText;

  final _dialogBorder = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  );

  void _showAction(
      BuildContext context, ga.ActivityType actionType, String groupId) {
    final myUid = Provider.of<UserProfile>(context, listen: false).uid;
    final _formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) {
        if (actionType == ga.ActivityType.messagePublish) {
          return AlertDialog(
            title: const Text("Post a message"),
            shape: _dialogBorder,
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please type a message or tap 'CLOSE'";
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: "Type your message",
                ),
                onChanged: (val) {
                  publishText = val;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CLOSE'),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var activity = ga.GroupActivity(
                        activityType: actionType,
                        activityDateTime: DateTime.now(),
                        activityOwner: myUid,
                        groupId: groupId,
                        messagePublishText: publishText,
                      );
                      activity.activityDateTime = DateTime.now();
                      try {
                        Provider.of<AllGroups>(context, listen: false)
                            .participate(activity);
                        Navigator.of(context).pop();
                      } catch (err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              err.toString(),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("POST"))
            ],
          );
        } else if (actionType == ga.ActivityType.fileUpload) {
          return ShareNotesDialog(
            groupId: groupId,
          );
          // } else if (actionType == ga.ActivityType.userAdded) {
          //   return AddUser(
          //     groupId: groupId,
          //   );
        } else {
          return const AlertDialog(
            content: Text("No valid actions"),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserGroup;
    final groupActivity =
        Provider.of<AllGroups>(context).groupActivity(args.docId!);
    // final participate = Provider.of(context)
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
                          // Create widgets to display specific user actions
                          .map(
                      (e) {
                        return DisplayNewPost(
                          groupActivity: e,
                        );
                      },
                    ).toList())
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
            onPressed: () => _showAction(
                context, ga.ActivityType.messagePublish, args.docId as String),
            icon: const Icon(
              Icons.message_outlined,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => _showAction(
                context, ga.ActivityType.fileUpload, args.docId as String),
            icon: const Icon(
              Icons.note_add_rounded,
              color: Colors.white,
            ),
          ),
          ActionButton(
            // onPressed: () => _showAction(
            //     context, ga.ActivityType.userAdded, args.docId as String),
            onPressed: () =>
                Navigator.pushNamed(context, '/all_contacts', arguments: args),
            icon: const Icon(
              Icons.person_add_alt_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
