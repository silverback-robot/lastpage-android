import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/all_oneonone_convos.dart';
import 'package:lastpage/models/groups/group_activity.dart' as ga;
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List;
    final convoId = args[0] as String;
    final oppositeProfile = args[1] as UserProfile;
    final conversationStream =
        Provider.of<AllConvos>(context).conversation(convoId);
    return Scaffold(
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
                    List<ga.GroupActivity>? allActivity = snapshot.data!;
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
          ), // Message TextField with Send Button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Form(
              key: _formKey,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: "Type your message",
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.white),
                      border: OutlineInputBorder(
                        // borderRadius:
                        //     BorderRadius.all(Radius.zero(5.0)),
                        borderSide: BorderSide(color: Colors.purpleAccent),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                // Second child is button
                IconButton(
                  icon: const Icon(Icons.send),
                  iconSize: 20.0,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  iconSize: 20.0,
                  onPressed: () {},
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}