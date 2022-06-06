import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/new_group.dart';
import 'package:lastpage/models/search_users/device_contacts.dart';
import 'package:lastpage/widgets/contacts/contacts_tile.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupRelevantContacts extends StatelessWidget {
  GroupRelevantContacts({Key? key}) : super(key: key);

  final List<String> selectedUsers = [];
  static final _log = Logger("AllContacts");
  @override
  Widget build(BuildContext context) {
    final groupInfo = ModalRoute.of(context)!.settings.arguments as UserGroup;
    var contactsPermission = Permission.contacts.request();
    return FutureBuilder(
        future: contactsPermission,
        builder: (context, AsyncSnapshot<PermissionStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isGranted) {
              final contactsList = Provider.of<LastpageContacts>(context)
                  .relevantContacts(groupInfo.members);
              return Scaffold(
                appBar: AppBar(actions: [
                  IconButton(
                      onPressed: (() =>
                          Provider.of<LastpageContacts>(context, listen: false)
                              .refreshContacts()),
                      icon: const Icon(Icons.refresh))
                ]),
                body: ListView(shrinkWrap: true, children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Your Contacts",
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: contactsList
                        .map((e) => ContactTile(
                              contact: e,
                              onTap: () {
                                if (selectedUsers.contains(e.uid)) {
                                  selectedUsers.remove(e.uid);
                                } else {
                                  selectedUsers.add(e.uid);
                                }
                              },
                            ))
                        .toList(),
                  )
                ]),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    if (selectedUsers.isNotEmpty) {
                      _log.info(
                          "Adding users ${selectedUsers.toString()} to group ${groupInfo.docId}");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Adding selected users to group.")));
                      await groupInfo.addMembersToGroup(selectedUsers);
                    }
                  },
                  child: const Icon(Icons.group_add_rounded),
                ),
              );
            }
          }
          return const Scaffold(
            body: Center(
              child: Text("Waiting for permission grant..."),
            ),
          );
        });
  }
}
