import 'package:lastpage/models/syllabus_data_models/subject.dart';

class Semester {
  late int semesterNumber;
  List<Subject> semesterSubjects = [];

  Semester.fromJson(int semNo, List<String> json) {
    semesterNumber = semNo;
    semesterSubjects = json
        .map(
          (e) => Subject.fetchData(e),
        )
        .toList();
  }
}
