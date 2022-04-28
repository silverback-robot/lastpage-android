import 'package:flutter/material.dart';
import 'package:lastpage/models/new_group.dart';
import 'package:lastpage/widgets/groups/create_new_group.dart';

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Groups!"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var _notesMetadata = await showDialog<NewGroup>(
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
