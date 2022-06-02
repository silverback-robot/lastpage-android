import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lastpage/models/export_pdf.dart';

enum NotesAction { shareNotes, exportPdf }

class NotesetTile extends StatefulWidget {
  const NotesetTile(
      {required this.title,
      required this.noOfPages,
      required this.createdDate,
      required this.downloadUrls,
      Key? key})
      : super(key: key);

  final String title;
  final int createdDate;
  final int noOfPages;
  final List<String> downloadUrls;

  @override
  State<NotesetTile> createState() => _NotesetTileState();
}

class _NotesetTileState extends State<NotesetTile> {
  @override
  Widget build(BuildContext context) {
    final todayTmp = DateTime.now();
    final createdDttm = DateTime.fromMillisecondsSinceEpoch(widget.createdDate);
    final createdDay =
        DateTime(createdDttm.year, createdDttm.month, createdDttm.day);
    final DateFormat formatter = DateFormat('d MMMM');
    final String formatted = formatter.format(createdDay);
    final today = DateTime(todayTmp.year, todayTmp.month, todayTmp.day);
    final diff = today.difference(createdDay).inDays;

    return GestureDetector(
      onTap: () {
        widget.downloadUrls.isNotEmpty
            ? Navigator.pushNamed(context, '/fullscreen_notes',
                arguments: widget.downloadUrls)
            : null;
      },
      child: Card(
        elevation: 1,
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          title: Text(widget.title),
          subtitle: Text(
              "${widget.noOfPages} ${widget.noOfPages > 1 ? "pages" : "page"}"),
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
                            urls: widget.downloadUrls);
                        print(pdf.absolute.toString());
                        break;
                      case (NotesAction.shareNotes):
                        print("Share Notes");
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
