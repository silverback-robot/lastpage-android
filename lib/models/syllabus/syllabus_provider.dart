import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:lastpage/models/syllabus/semester.dart';
import 'package:lastpage/models/syllabus/subject.dart';
import 'package:lastpage/models/syllabus/syllabus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

//TODO: CRITICAL: Set `syllabusYamlUrl` in userProfile document at the time of profile creation
class SyllabusProvider extends ChangeNotifier {
  Syllabus? syllabus;

  SyllabusProvider() {
    _processSyllabusYaml();
    notifyListeners();
  }

  Future<bool> refreshSyllabus() async {
    // Download and override existing syllabus YAML (syllabus change detected during sync)
    final prefs = await SharedPreferences.getInstance();
    var syllabusYamlUrl = prefs.getString('syllabusYamlUrl')!;
    await _downloadSyllabus(syllabusYamlUrl);
    var status = await _processSyllabusYaml();
    if (status) {
      notifyListeners();
      return status;
    } else {
      return false;
    }
  }

  //Check whether syllabus YAML exists
  Future<String> _getSyllabusPath() async {
    var appDir = await getApplicationSupportDirectory();
    var syllabusPath = io.File('${appDir.path}\\syllabus.yaml');
    var syllabusExists = syllabusPath.existsSync();
    if (!syllabusExists) {
      // Get user's syllabus URL from userProfile
      final prefs = await SharedPreferences.getInstance();
      var syllabusYamlUrl = prefs.getString('syllabusYamlUrl')!;
      // Download and rename syllabus yaml as `syllabus.yaml`
      var syllabusYamlPath = await _downloadSyllabus(syllabusYamlUrl);
      return syllabusYamlPath;
    } else {
      return syllabusPath.path;
    }
  }

  // Download syllabus YAML and set proper name
  Future<String> _downloadSyllabus(String url) async {
    try {
      var saveDir = await getApplicationSupportDirectory();
      String filename = "syllabus.yaml";
      String savePath = "${saveDir.path}/$filename";

      io.File file = io.File(savePath);
      final httpsReference = FirebaseStorage.instance.refFromURL(url);
      final downloadSyllabus = httpsReference.writeToFile(file);
      await downloadSyllabus.then(
          (p0) => print("Syllabus Download Task Status: ${p0.state.name}"));
      return savePath;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> _processSyllabusYaml() async {
    var syllabusPath = await _getSyllabusPath();
    final data = await io.File(syllabusPath).readAsString();
    final mapData = loadYaml(data);

    var university = mapData["university"];
    var course = mapData["course"];
    var syllabusVersion = mapData["syllabus_version"];
    var subjectsList = ((mapData["subjects"] ?? []) as List);
    var semesterYamlMap = (mapData["semesterSubjects"] as YamlMap);
    List<Semester> semesters = [];
    for (var sem in semesterYamlMap.entries) {
      int semesterNo = int.parse(sem.key.toString().trim());
      List<String> semesterSubjects = (sem.value as YamlList).cast();
      semesters.add(
          Semester(semesterNo: semesterNo, semesterSubjects: semesterSubjects));
    }
    List<Subject> subjects = [];
    for (var subject in subjectsList) {
      var subjectCode = subject['subjectCode'] as String;
      var subjectTitle = subject['subjectTitle'] as String;
      var LTPC = subject['LTPC'] as String;
      var subjectUnitsRaw = ((subject['subjectUnits'] ?? []) as List);
      List<SubjectUnit> subjectUnits = [];
      for (var item in subjectUnitsRaw) {
        var subjectUnit = SubjectUnit(
          unitNumber: item['unitNumber'],
          unitTitle: item['unitTitle'],
          unitContents: item['unitContents'],
        );
        subjectUnits.add(subjectUnit);
      }
      var subjectInfo = Subject(
          subjectCode: subjectCode,
          subjectTitle: subjectTitle,
          LTPC: LTPC,
          subjectUnits: subjectUnits);
      subjects.add(subjectInfo);
    }
    syllabus = Syllabus(
      university: university,
      course: course,
      syllabusVersion: syllabusVersion,
      subjects: subjects,
      semesters: semesters,
    );
    notifyListeners();
    return true;
  }
}
