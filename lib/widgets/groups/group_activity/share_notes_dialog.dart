import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ShareNotesDialog extends StatefulWidget {
  const ShareNotesDialog({Key? key}) : super(key: key);

  @override
  State<ShareNotesDialog> createState() => _ShareNotesDialogState();
}

class _ShareNotesDialogState extends State<ShareNotesDialog> {
  final todayTmp = DateTime.now();
  final DateFormat formattedTime = DateFormat('hh:mm a');
  final DateFormat formattedDate = DateFormat('d MMMM');
  List<PagesUploadMetadata> selectedNotes = [];

  @override
  Widget build(BuildContext context) {
    var userStorageDocs = Provider.of<UserStorage>(context).userStorageDocs;
    return AlertDialog(
      title: const Text("Share notes with group"),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      content: ListView(
        shrinkWrap: true,
        children: userStorageDocs.map((note) {
          final createdDttm =
              DateTime.fromMillisecondsSinceEpoch(note.createdDateTime);
          final diff = todayTmp.difference(createdDttm).inDays;
          return ListTile(
            title: Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              diff == 0
                  ? "Today, ${formattedTime.format(createdDttm)}"
                  : diff == 1
                      ? "Yesterday"
                      : formattedDate.format(createdDttm),
            ),
            trailing: Checkbox(
                value:
                    selectedNotes.any((element) => element.setId == note.setId),
                onChanged: (bool? value) {
                  if (value!) {
                    if (!selectedNotes
                        .any((element) => element.setId == note.setId)) {
                      setState(() {
                        selectedNotes.add(note);
                      });
                    }
                  } else {
                    if (selectedNotes
                        .any((element) => element.setId == note.setId)) {
                      setState(() {
                        selectedNotes.removeWhere(
                            (PagesUploadMetadata currentNote) =>
                                currentNote.setId == note.setId);
                      });
                    }
                  }
                }),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("CLOSE"),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text("SHARE"),
        ),
      ],
    );
  }
}
