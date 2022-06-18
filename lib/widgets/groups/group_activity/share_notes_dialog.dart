import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/models/groups/share_note.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

enum ShareNoteWizard { selectNotes, addMessage }

class ShareNotesDialog extends StatefulWidget {
  const ShareNotesDialog({required this.groupId, Key? key}) : super(key: key);
  final String groupId;

  @override
  State<ShareNotesDialog> createState() => _ShareNotesDialogState();
}

class _ShareNotesDialogState extends State<ShareNotesDialog> {
  final todayTmp = DateTime.now();
  final DateFormat formattedTime = DateFormat('hh:mm a');
  final DateFormat formattedDate = DateFormat('d MMMM');
  ShareNoteWizard currentScreen = ShareNoteWizard.selectNotes;
  PagesUploadMetadata? selectedNote;
  String? publishMessage;

  @override
  Widget build(BuildContext context) {
    var userStorageDocs = Provider.of<UserStorage>(context).userStorageDocs;
    var _selected = false;
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text("Share notes with group"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        content: currentScreen == ShareNoteWizard.selectNotes
            ? SizedBox(
                width: 300,
                height: 250,
                child: ListView(
                  shrinkWrap: true,
                  children: userStorageDocs.map((note) {
                    final createdDttm = DateTime.fromMillisecondsSinceEpoch(
                        note.createdDateTime);
                    final diff = todayTmp.difference(createdDttm).inDays;
                    return ListTile(
                      title: Text(
                        note.title,
                        // maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        diff == 0
                            ? "Today, ${formattedTime.format(createdDttm)}"
                            : diff == 1
                                ? "Yesterday"
                                : formattedDate.format(createdDttm),
                      ),
                      selected: _selected,
                      selectedTileColor: _selected ? Colors.grey[400] : null,
                      onTap: () {
                        setState(
                          () {
                            _selected = !_selected;
                            selectedNote = note;
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              )
            : TextFormField(
                autocorrect: true,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: "Add a message (optional).",
                ),
                onChanged: (val) {
                  publishMessage = val;
                },
              ),
        actions: [
          TextButton(
            onPressed: () {
              selectedNote = null;
              _selected = false;
              if (currentScreen == ShareNoteWizard.selectNotes) {
                Navigator.of(context).pop();
              } else {
                setState(() {
                  currentScreen = ShareNoteWizard.selectNotes;
                });
              }
            },
            child: Text(currentScreen == ShareNoteWizard.selectNotes
                ? "CLOSE"
                : "BACK"),
          ),
          ElevatedButton(
            onPressed: selectedNote != null
                ? () async {
                    if (currentScreen == ShareNoteWizard.selectNotes) {
                      setState(() {
                        currentScreen = ShareNoteWizard.addMessage;
                      });
                    } else if (selectedNote != null) {
                      // Push to 'groups/xxx/activity' collection
                      var shareNote = ShareNote(
                          uploadData: selectedNote!, message: publishMessage);
                      shareNote.postInGroup(widget.groupId);
                      // Pop out of wizard
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            child: Text(currentScreen == ShareNoteWizard.selectNotes
                ? "NEXT"
                : "SHARE"),
          ),
        ],
      ),
    );
  }
}
