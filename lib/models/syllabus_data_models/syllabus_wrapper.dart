import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastpage/models/syllabus_data_models/course.dart';
import 'package:lastpage/models/syllabus_data_models/subject.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyallabusWrapper extends ChangeNotifier {
  SyallabusWrapper() {
    fetchSyllabus();
    fetchSyllabusYaml();
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
        var subjectData = await Subject.fetchData(subCodes);
        _subjects.add(subjectData);
        sem.semesterSubjects.add(subjectData);
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

  Future<void> fetchSyllabusYaml() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final syllabusYamlUrl =
          prefs.getString('syllabusYamlUrl') ?? 'UNAVAILABLE';
      print(prefs.getKeys().toString());
      print("$syllabusYamlUrl :: ${prefs.getBool('syllabusYamlUrlChanged')}");
      if (syllabusYamlUrl != 'UNAVAILABLE' &&
          (prefs.getBool('syllabusYamlUrlChanged') ?? false)) {
        final appDir = await getApplicationSupportDirectory();
        final syllabusYaml = File("${appDir.absolute.path}/syllabus.yaml");
        print(syllabusYaml.absolute.path);
        final httpsReference =
            FirebaseStorage.instance.refFromURL(syllabusYamlUrl);
        final downloadSyllabus = httpsReference.writeToFile(syllabusYaml);
        downloadSyllabus.then(
            (p0) => print("Syllabus Download Task Status: ${p0.state.name}"));
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
