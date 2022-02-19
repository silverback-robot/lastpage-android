import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus_data_models/subject.dart';
import 'package:lastpage/widgets/syllabus/chapter_card.dart';

class SingleSubject extends StatelessWidget {
  const SingleSubject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Subject;
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
                args.subjectTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(args.subjectCode.padRight(10)),
                    Text("${args.credits!.toString()} Credits"),
                  ],
                ),
                Text(args.category!),
              ],
            ),
          ),
          Column(
            children: args.units.map((e) => ChapterCard(e)).toList(),
          ),
        ],
      ))),
    );
  }
}
