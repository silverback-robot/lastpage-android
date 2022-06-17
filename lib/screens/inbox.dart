import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/all_groups.dart';
import 'package:lastpage/models/groups/all_oneonone_convos.dart';
import 'package:lastpage/models/groups/new_group.dart';
import 'package:lastpage/models/groups/oneonone_convo.dart';
import 'package:lastpage/widgets/groups/conversation_tile.dart';
import 'package:lastpage/widgets/groups/create_new_group.dart';
import 'package:lastpage/widgets/groups/group_tile.dart';
import 'package:provider/provider.dart';

class Inbox extends StatelessWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inbox")),
      body: SafeArea(
        child: ListView(
          children: [
            StreamBuilder(
                stream: Provider.of<AllGroups>(context).participatingGroups,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Checking your Groups..."),
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Oops! Something went wrong..."),
                      );
                    } else if (snapshot.hasData) {
                      var participatingGroups =
                          snapshot.data as List<UserGroup>;
                      var groupTiles = participatingGroups
                          .map((e) => GroupTile(info: e))
                          .toList();
                      return Column(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: groupTiles,
                        ).toList(),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20,
                            ),
                            Text("You're not part of any groups yet..."),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(snapshot.connectionState.toString()),
                    );
                  }
                }),
            // StreamBuilder for OneonOne Conversations
            StreamBuilder(
              stream: Provider.of<AllConvos>(context).allConversations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Checking your Conversations..."),
                      ],
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Oops! Something went wrong..."),
                    );
                  } else if (snapshot.hasData) {
                    var participatingConvos =
                        snapshot.data as List<OneOnOneConvo>;
                    var convoTiles = participatingConvos
                        .map((e) => ConversationTile(conversation: e))
                        .toList();
                    return Column(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: convoTiles,
                      ).toList(),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text("No conversations."),
                        ],
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var _notesMetadata = await showDialog<UserGroup>(
              context: context,
              builder: (BuildContext context) {
                return CreateNewGroup(context: context);
              });
        },
        icon: const Icon(Icons.add),
        label: const Text("New Group"),
      ),
    );
  }
}
