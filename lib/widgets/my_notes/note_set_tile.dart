import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/models/export_pdf.dart';
import 'package:lastpage/models/show_notification.dart';

enum NotesAction { shareNotes, exportPdf }

class NotesetTile extends StatefulWidget {
  const NotesetTile({required this.notesData, Key? key}) : super(key: key);
  final PagesUploadMetadata notesData;

  @override
  State<NotesetTile> createState() => _NotesetTileState();
}

class _NotesetTileState extends State<NotesetTile> {
  @override
  Widget build(BuildContext context) {
    final notesData = widget.notesData;
    final noOfPages = notesData.downloadUrls.length;

    final todayTmp = DateTime.now();
    final createdDttm =
        DateTime.fromMillisecondsSinceEpoch(notesData.createdDateTime);
    final createdDay =
        DateTime(createdDttm.year, createdDttm.month, createdDttm.day);
    final DateFormat formatter = DateFormat('d MMMM');
    final String formatted = formatter.format(createdDay);
    final today = DateTime(todayTmp.year, todayTmp.month, todayTmp.day);
    final diff = today.difference(createdDay).inDays;

    return GestureDetector(
      onTap: () {
        notesData.downloadUrls.isNotEmpty
            ? Navigator.pushNamed(context, '/fullscreen_notes',
                arguments: notesData.downloadUrls)
            : null;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(5),
          leading: const Icon(Icons.notes),
          title: Text(notesData.title),
          subtitle: Text(
              "${noOfPages.toString()} ${noOfPages > 1 ? "pages" : "page"}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                diff == 0
                    ? "Today"
                    : diff == 1
                        ? "Yesterday"
                        : formatted,
                style: const TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              PopupMenuButton<NotesAction>(
                  onSelected: (NotesAction item) async {
                    switch (item) {
                      case (NotesAction.exportPdf):
                        final pdf = await ExportPDF.exportPDF(
                            urls: notesData.downloadUrls);
                        print(pdf.absolute.toString());
                        ShowNotification.showNotification(
                            title: "PDF Export Complete!",
                            body: "Tap to open exported PDF.",
                            payload: pdf.path.toString());
                        break;
                      case (NotesAction.shareNotes):
                        print("Share Notes");
                        Navigator.pushNamed(context, '/share_notes_individual',
                            arguments: notesData);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<NotesAction>>[
                        const PopupMenuItem<NotesAction>(
                          value: NotesAction.shareNotes,
                          child: Text('Share notes'),
                        ),
                        const PopupMenuItem<NotesAction>(
                          value: NotesAction.exportPdf,
                          child: Text('Export as PDF'),
                        ),
                      ]),
            ],
          ),
        ),
      ),
    );
  }
}
