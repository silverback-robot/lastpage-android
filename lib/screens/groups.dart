import 'package:flutter/material.dart';
import 'package:lastpage/models/all_groups.dart';
import 'package:lastpage/models/new_group.dart';
import 'package:lastpage/widgets/groups/create_new_group.dart';
import 'package:provider/provider.dart';

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
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
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Oops! Something went wrong..."),
                );
              } else if (snapshot.hasData) {
                return const Center(
                  child: Text("Got Group Data!"),
                );
                // TODO: Render Group Tiles
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
