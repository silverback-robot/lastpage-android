import 'package:lastpage/models/syllabus_data_models/subject.dart';

class Semester {
  late int semesterNumber;
  List<Subject> semesterSubjects = [];
  List<String> semesterSubjectCodes = [];

  Semester.fromJson(int semNo, List<String> json) {
    semesterNumber = semNo;
    // semesterSubjects = json
    //     .map((e) async {
    //       var subject = await Subject.fetchData(e);
    //       return subject;
    //     })
    //     .cast<Subject>()
    //     .toList();

    semesterSubjectCodes = json;
  }
}
