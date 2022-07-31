import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';
import 'package:lastpage/widgets/syllabus/chapter_card.dart';
import 'package:provider/provider.dart';

class SingleSubject extends StatelessWidget {
  const SingleSubject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final subject = Provider.of<SyllabusProvider>(context)
        .syllabus!
        .subjects
        .firstWhere((element) => element.subjectCode == args);
    var ltpc = subject.LTPC!.replaceAll(' ', '').toUpperCase();
    var credits =
        ltpc.length == 8 ? "${ltpc[7].toString()} Credits" : "No info";
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                subject.subjectTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(subject.subjectCode.padRight(10)),
                    Text(credits),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children:
                subject.subjectUnits?.map((e) => ChapterCard(e)).toList() ?? [],
          ),
        ],
      ))),
    );
  }
}
