import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesetTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final todayTmp = DateTime.now();
    final createdDttm = DateTime.fromMillisecondsSinceEpoch(createdDate);
    final createdDay =
        DateTime(createdDttm.year, createdDttm.month, createdDttm.day);
    final DateFormat formatter = DateFormat('d MMMM');
    final String formatted = formatter.format(createdDay);
    final today = DateTime(todayTmp.year, todayTmp.month, todayTmp.day);
    final diff = today.difference(createdDay).inDays;

    return GestureDetector(
      onTap: () {
        downloadUrls.isNotEmpty
            ? Navigator.pushNamed(context, '/fullscreen_notes',
                arguments: downloadUrls)
            : null;
      },
      child: Card(
        elevation: 1,
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          title: Text(title),
          subtitle: Text("$noOfPages ${noOfPages > 1 ? "pages" : "page"}"),
          trailing: Text(
              diff == 0
                  ? "Today"
                  : diff == 1
                      ? "Yesterday"
                      : formatted,
              style: const TextStyle(
                  color: Colors.black54, fontStyle: FontStyle.italic)),
        ),
      ),
    );
  }
}
