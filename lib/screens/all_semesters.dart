import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus/syllabus.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class AllSemesters extends StatelessWidget {
  AllSemesters({Key? key}) : super(key: key);

  final _log = Logger('AllSemesters');
  @override
  Widget build(BuildContext context) {
    _log.info('build method called');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Semester"),
      ),
      body: FutureBuilder(
          future: Provider.of<SyllabusProvider>(context).getSyllabusData(),
          builder: (BuildContext context, AsyncSnapshot<Syllabus> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              Syllabus syllabus = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.builder(
                    itemCount: syllabus.semesters.length,
                    itemBuilder: (context, index) {
                      var userCourse = syllabus.semesters[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          title: Text(
                              "Semester ${userCourse.semesterNo.toString()}"),
                          subtitle: Text(
                              "${userCourse.semesterSubjects.length.toString()} subjects"),
                          onTap: () => Navigator.pushNamed(
                              context, '/single_semester',
                              arguments: userCourse.semesterSubjects),
                        ),
                      );
                    }),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(children: const [
                  Icon(Icons.error_outline_rounded),
                  SizedBox(
                    height: 32,
                  ),
                  Text('Something went wrong.'),
                ]),
              );
            } else {
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
          }),
    );
  }
}
