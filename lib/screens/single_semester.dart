import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus_data_models/subject.dart';

class SingleSemester extends StatelessWidget {
  const SingleSemester({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<Subject>;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: args.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(args[index].subjectTitle),
                  subtitle: Text(args[index].subjectCode),
                  onTap: () => Navigator.pushNamed(context, '/single_subject',
                      arguments: args[index]),
                ),
              );
            }),
      ),
    );
  }
}
