import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewPost extends StatelessWidget {
  const NewPost({required this.groupActivity, Key? key}) : super(key: key);

  final GroupActivity groupActivity;

  @override
  Widget build(BuildContext context) {
    UserProfile? senderProfile;

    final todayTmp = DateTime.now();
    final DateFormat formattedTime = DateFormat('hh:mm a');
    final DateFormat formattedDate = DateFormat('d MMMM');
    final String formatted =
        formattedDate.format(groupActivity.activityDateTime);
    final today = DateTime(todayTmp.year, todayTmp.month, todayTmp.day);
    final diff = today.difference(groupActivity.activityDateTime).inDays;

    return FutureBuilder(
      future: Provider.of<UserProfile>(context)
          .fetchUserProfile(groupActivity.activityOwner)
          .then((value) => senderProfile = value!),
      builder: (context, snapshot) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 2,
          child: Container(
            color: Colors.grey[200],
            width: double.infinity * 0.8,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              senderProfile != null
                  ? ListTile(
                      dense: true,
                      leading: senderProfile!.avatar != null
                          ? CircleAvatar(
                              // radius: 20.0,
                              backgroundImage:
                                  NetworkImage(senderProfile!.avatar!),
                              backgroundColor: Colors.transparent,
                            )
                          : const Icon(Icons.account_circle),
                      title: Row(
                        children: [
                          Text(
                            senderProfile!.name!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                          Text(
                            " posted a message",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      subtitle: Text(diff == 0
                          ? "Today, ${formattedTime.format(groupActivity.activityDateTime)}"
                          : diff == 1
                              ? "Yesterday"
                              : formatted),
                      trailing: IconButton(
                          icon: const Icon(Icons.more_vert), onPressed: () {}),
                    )
                  : const SizedBox(),
              Container(
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
              ),
            ]),
          ),
        );
      },
    );
  }
}
