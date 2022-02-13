import 'package:lastpage/models/syllabus_data_models/subject_unit.dart';

class Subject {
  late String subjectCode;
  late String subjectTitle;
  String? subjectType;
  String? category;
  int? credits;
  String? syllabusVersion;
  List<SubjectUnit> units = [];

  Subject.fromJson(Map<String, dynamic> json) {
    subjectCode = json['courseCode'];
    subjectTitle = json['courseTitle'];
    subjectType = json['courseType'];
    category = json['category'];
    credits = json['credits'] as int;
    syllabusVersion = json['syllabusVersion'];

    Map<String, dynamic> unitsJson = json['units'];
    units = unitsJson.entries
        .map(
          (e) => SubjectUnit.fromJson(e.key as int, e.value),
        )
        .toList();
  }

  Subject.fetchData(String subjectCode) {}
}
