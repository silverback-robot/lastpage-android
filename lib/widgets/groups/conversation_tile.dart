import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/oneonone_convo.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:provider/provider.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({required this.conversation, Key? key})
      : super(key: key);

  final OneOnOneConvo conversation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<UserProfile>(context)
            .fetchUserProfile(conversation.oppositeUid),
        builder: (context, AsyncSnapshot<UserProfile?> snapshot) {
          if (snapshot.hasData) {
            var profile = snapshot.data;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(profile!.name!),
                leading: profile.avatar != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(profile.avatar!),
                        radius: 24,
                      )
                    : const CircleAvatar(child: Icon(Icons.person)),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => Navigator.pushNamed(context, '/view_conversation',
                    arguments: [
                      conversation.convoId,
                      profile,
                      conversation.myUid,
                    ]),
              ),
            );
          }

          return const SizedBox();
        });
  }
}
