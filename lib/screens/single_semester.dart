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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: args.length,
            itemBuilder: (context, index) {
              var subject = subjects
                  .firstWhere((element) => element.subjectCode == args[index]);
              return Card(
                child: ListTile(
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
