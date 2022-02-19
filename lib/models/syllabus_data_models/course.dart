import 'package:lastpage/models/syllabus_data_models/semester.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lastpage/models/user_profile.dart';

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
      var semNo = int.parse(key);
      List<String> subCodes =
          (value as List).map((subCode) => subCode as String).toList();
      allSemesters.add(
        Semester.fromJson(semNo, subCodes),
      );
    });
  }

  static Future<Course> fetch() async {
    final _db = FirebaseFirestore.instance;
    var userProfile = await UserProfile.fetchProfile();
    var userCourseRaw = await _db
        .collection("universities")
        .doc(userProfile.university)
        .collection("departments")
        .where("deptName", isEqualTo: userProfile.department!.toUpperCase())
        .limit(1)
        .get();

    var userCourse = userCourseRaw.docs.first.data();
    var courseData = Course.fromJson(userCourse);
    return courseData;
  }
}
