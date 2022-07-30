import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/all_oneonone_convos.dart';
import 'package:lastpage/models/groups/group_activity.dart' as ga;
import 'package:lastpage/models/lastpage_colors.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:lastpage/widgets/groups/group_activity/display_new_post.dart';
import 'package:provider/provider.dart';

// Similar to ViewGroupActivity, but for one-on-one conversations
class ViewConversation extends StatefulWidget {
  const ViewConversation({Key? key}) : super(key: key);

  @override
  State<ViewConversation> createState() => _ViewConversationState();
}

class _ViewConversationState extends State<ViewConversation> {
  final msgController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List;
    final convoId = args[0] as String;
    final oppositeProfile = args[1] as UserProfile;
    final myUid = args[2] as String;
    final conversationStream =
        Provider.of<AllConvos>(context).conversation(convoId);
    return Scaffold(
      backgroundColor: LastpageColors.white,
      appBar: AppBar(
        leadingWidth: 40,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: oppositeProfile.avatar != null
                  ? NetworkImage(oppositeProfile.avatar!)
                  : null,
              child: oppositeProfile.avatar != null
                  ? null
                  : const Icon(Icons.person),
            ),
            const SizedBox(width: 20),
            Text(oppositeProfile.name ?? "Conversation"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: conversationStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ga.GroupActivity>> snapshot) {
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
                    List<ga.GroupActivity> allActivity = snapshot.data!;
                    return allActivity.isNotEmpty
                        ? ListView(
                            padding: const EdgeInsets.all(4),
                            primary: true,
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
          ), // Message TextField with Send Button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            margin: const EdgeInsets.all(2.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Expanded(
                child: TextField(
                  autocorrect: false,
                  controller: msgController,
                  decoration: const InputDecoration(
                    labelText: "Type your message",
                    border: OutlineInputBorder(
                      // borderRadius:
                      //     BorderRadius.all(Radius.zero(5.0)),
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                ),
              ),
              // Second child is button
              IconButton(
                icon: const Icon(Icons.share),
                iconSize: 20.0,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send),
                iconSize: 20.0,
                onPressed: msgController.text.isNotEmpty
                    ? () async {
                        print(
                            "msgController.text.isNotEmpty: ${msgController.text.isNotEmpty}");
                        var currentActivity = ga.GroupActivity(
                          groupId: convoId,
                          activityType: ga.ActivityType.messagePublish,
                          activityOwner: myUid,
                          activityDateTime: DateTime.now(),
                          messagePublishText: msgController.text,
                        );
                        try {
                          await Provider.of<AllConvos>(context, listen: false)
                              .participate(currentActivity);
                          msgController.clear();
                        } catch (err) {
                          print(err.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong"),
                            ),
                          );
                        }
                      }
                    : () {
                        print(
                            "msgController.text.isNotEmpty: ${msgController.text.isNotEmpty}");
                      },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
