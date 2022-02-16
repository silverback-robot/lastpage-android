import 'package:lastpage/models/syllabus_data_models/subject_unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lastpage/models/user_profile.dart';

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
    credits = int.parse(json['credits']);
    syllabusVersion = json['syllabusVersion'];

    Map<String, dynamic> unitsJson = json['units'];
    units = unitsJson.entries
        .map(
          (e) => SubjectUnit.fromJson(int.parse(e.key), e.value),
        )
        .toList();
  }

  static Future<Subject> fetchData(String subjectCode) async {
    final _db = FirebaseFirestore.instance;
    var userProfile = await UserProfile.fetchProfile();
    var subjectDataRaw = await _db
        .collection("universities")
        .doc(userProfile.university)
        .collection("subjects")
        .where("courseCode", isEqualTo: subjectCode)
        .limit(1)
        .get();
    var subjectData = subjectDataRaw.docs.first.data();
    return Subject.fromJson(subjectData);
  }
}
