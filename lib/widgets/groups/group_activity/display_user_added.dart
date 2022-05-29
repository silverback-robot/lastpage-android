import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class DisplayUserAdded extends StatelessWidget {
  const DisplayUserAdded({required this.groupActivity, Key? key})
      : super(key: key);
  final GroupActivity groupActivity;
  static final _log = Logger("DisplayUserAdded");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProfile>(context)
          .fetchUserProfile(groupActivity.userAddedUID),
      // .then((value) => senderProfile = value!),
      builder: (context, AsyncSnapshot<UserProfile?> snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          _log.severe("Error in retrieving/processing new user's info.");
          _log.severe(snapshot.error);
          return const Text("Something went wrong");
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              child: ListTile(
                dense: true,
                leading: snapshot.data?.avatar != null
                    ? CircleAvatar(
                        // radius: 20.0,
                        backgroundImage: NetworkImage(snapshot.data!.avatar!),
                        backgroundColor: Colors.transparent,
                      )
                    : const Icon(Icons.account_circle),
                title: Text(
                  snapshot.data!.name!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                subtitle: const Text("User added to group."),
              ),
            ),
          ),
        );
      },
    );
  }
}
