import 'package:lastpage/models/syllabus_data_models/semester.dart';

class Course {
  late String courseName;
  String? syllabusVersion;
  late String courseType;
  List<Semester> allSemesters = [];

  Course.fromJson(Map<String, dynamic> json) {
    courseName = json['deptName'];
    syllabusVersion = json['syllabusVersion'];
    courseType = json['courseType'];

    Map<String, dynamic> allCourses = json['allCourses'];
    allCourses.forEach((key, value) {
      allSemesters.add(
        Semester.fromJson(key as int, value),
      );
    });
  }
}
