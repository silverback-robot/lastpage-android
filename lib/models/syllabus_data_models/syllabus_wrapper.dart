import 'package:flutter/cupertino.dart';
import 'package:lastpage/models/syllabus_data_models/course.dart';
import 'package:lastpage/models/syllabus_data_models/subject.dart';

class SyallabusWrapper extends ChangeNotifier {
  SyallabusWrapper() {
    fetchSyllabus();
  }
  Course? _course;
  final List<Subject> _subjects = [];

  Course? get course => _course;
  List<Subject> get subjects => _subjects;

  Future<void> _populateCourse() async {
    _course = await Course.fetch();
    notifyListeners();
  }

  Future<void> _populateSubjects() async {
    for (var sem in _course!.allSemesters) {
      for (var subCodes in sem.semesterSubjectCodes) {
        _subjects.add(await Subject.fetchData(subCodes));
      }
    }
    notifyListeners();
  }

  Future<void> fetchSyllabus() async {
    await _populateCourse();
    if (course != null) {
      await _populateSubjects();
    }
  }
}
