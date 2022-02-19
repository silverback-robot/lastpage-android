import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/syllabus_data_models/syllabus_wrapper.dart';

class AllSemesters extends StatelessWidget {
  const AllSemesters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: Provider.of<SyallabusWrapper>(context)
                .course!
                .allSemesters
                .length,
            itemBuilder: (context, index) {
              var userCourse = Provider.of<SyallabusWrapper>(context)
                  .course!
                  .allSemesters[index];
              return Card(
                child: ListTile(
                  title:
                      Text("Semester ${userCourse.semesterNumber.toString()}"),
                  subtitle: Text(
                      "${userCourse.semesterSubjectCodes.length.toString()} subjects"),
                  onTap: () => Navigator.pushNamed(context, '/syllabus',
                      arguments: userCourse.semesterSubjects),
                ),
              );
            }),
      ),
    );
  }
}
