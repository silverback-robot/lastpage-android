import 'package:flutter/material.dart';
import 'package:lastpage/models/search_users/device_contacts.dart';
import 'package:lastpage/widgets/contacts/contacts_tile.dart';
import 'package:provider/provider.dart';

class AllContacts extends StatelessWidget {
  const AllContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupId = ModalRoute.of(context)!.settings.arguments as String;
    final contactsList =
        Provider.of<LastpageContacts>(context).contactsOnLastpage;
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: contactsList.map((e) => ContactTile(contact: e)).toList(),
      ),
    );
  }
}
