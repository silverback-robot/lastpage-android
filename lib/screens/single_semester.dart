import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';
import 'package:provider/provider.dart';

class SingleSemester extends StatelessWidget {
  const SingleSemester({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<String>;
    final subjects = Provider.of<SyllabusProvider>(context).syllabus!.subjects;
    return Scaffold(
      appBar: AppBar(title: const Text('Select Subject')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
            itemCount: args.length,
            itemBuilder: (context, index) {
              var subject = subjects
                  .firstWhere((element) => element.subjectCode == args[index]);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  title: Text(subject.subjectTitle),
                  subtitle: Text(subject.subjectCode),
                  onTap: () => Navigator.pushNamed(context, '/single_subject',
                      arguments: args[index]),
                ),
              );
            }),
      ),
    );
  }
}
