import 'package:flutter/material.dart';
import 'package:lastpage/models/search_users/device_contacts.dart';
import 'package:lastpage/widgets/contacts/contacts_tile.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AllContacts extends StatelessWidget {
  const AllContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupId = ModalRoute.of(context)!.settings.arguments as String;
    var contactsPermission = Permission.contacts.request();
    return FutureBuilder(
        future: contactsPermission,
        builder: (context, AsyncSnapshot<PermissionStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isGranted) {
              final contactsList =
                  Provider.of<LastpageContacts>(context).contactsOnLastpage;
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
                        .map((e) => ContactTile(contact: e))
                        .toList(),
                  )
                ]),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
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
