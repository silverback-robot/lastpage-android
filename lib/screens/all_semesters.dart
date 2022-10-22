import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';
import 'package:provider/provider.dart';

class AllSemesters extends StatelessWidget {
  const AllSemesters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dataState = Provider.of<SyllabusProvider>(context, listen: false)
            .syllabus
            ?.subjects
            .isNotEmpty ??
        false;
    if (!_dataState) {
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text("Turning pages..."),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Semester"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: Provider.of<SyllabusProvider>(context)
                .syllabus!
                .semesters
                .length,
            itemBuilder: (context, index) {
              var userCourse = Provider.of<SyllabusProvider>(context)
                  .syllabus!
                  .semesters[index];
              return Card(
                child: ListTile(
                  title: Text("Semester ${userCourse.semesterNo.toString()}"),
                  subtitle: Text(
                      "${userCourse.semesterSubjects.length.toString()} subjects"),
                  onTap: () => Navigator.pushNamed(context, '/single_semester',
                      arguments: userCourse.semesterSubjects),
                ),
              );
            }),
      ),
    );
  }
}
