import 'package:lastpage/models/syllabus/semester.dart';
import 'package:lastpage/models/syllabus/subject.dart';

class Syllabus {
  String university;
  String course;
  String syllabusVersion;
  List<Subject> subjects;
  List<Semester> semesters;

  Syllabus({
    required this.university,
    required this.course,
    required this.syllabusVersion,
    required this.subjects,
    required this.semesters,
  });
}
