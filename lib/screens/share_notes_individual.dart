import 'package:flutter/material.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/models/groups/share_note.dart';
import 'package:lastpage/models/search_users/device_contacts.dart';
import 'package:lastpage/widgets/contacts/contacts_tile.dart';
import 'package:provider/provider.dart';

class ShareNotesIndividual extends StatelessWidget {
  const ShareNotesIndividual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final individualContacts =
        Provider.of<LastpageContacts>(context).contactsOnLastpage;
    final notesData =
        ModalRoute.of(context)!.settings.arguments as PagesUploadMetadata;
    return Scaffold(
      body: ListView(
        children: individualContacts
            .map(
              (contact) => ContactTile(
                contact: contact,
                onTap: () {
                  var shareNote =
                      ShareNote(uploadData: notesData, message: null);
                  shareNote.shareNotesWithDeviceContacts(contact.uid);
                  // Pop out of wizard
                  Navigator.of(context).pop();
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
