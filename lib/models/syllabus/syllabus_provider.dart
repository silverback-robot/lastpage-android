import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:lastpage/models/syllabus/semester.dart';
import 'package:lastpage/models/syllabus/subject.dart';
import 'package:lastpage/models/syllabus/syllabus.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

//TODO: Refactor methods to do one action per method (single responsibility)
class SyllabusProvider extends ChangeNotifier {
  Syllabus? _syllabus;
  Syllabus? get syllabus => _syllabus;
  static final _log = Logger('SyllabusProvider');

  Future<bool> refreshSyllabus() async {
    _log.info('refreshSyllabus method called');
    // Download and override existing syllabus YAML (syllabus change detected during sync)
    final prefs = await SharedPreferences.getInstance();
    var syllabusYamlUrl = prefs.getString('syllabusYamlUrl');
    var syllabusYamlUrlChanged =
        prefs.getBool('syllabusYamlUrlChanged') ?? true;

    _log.info('syllabusYamlUrl: $syllabusYamlUrl');
    _log.info('syllabusYamlUrl: $syllabusYamlUrlChanged');
    _log.info('No change in Syllabus YAML URL. Checking local syllabus...');

    var localSyllabusAvailable = await checkLocalSyllabus();
    _log.info('localSyllabusAvailable: $localSyllabusAvailable');

    // Download and Process YAML only if syllabusYamlUrlChanged is set to true (when refreshing userProfile)
    // or if local syllabus YAML file does not exist
    if ((syllabusYamlUrlChanged || !localSyllabusAvailable) &&
        syllabusYamlUrl != null) {
      await _downloadSyllabus(syllabusYamlUrl);
      var status = await _processSyllabusYaml();
      _log.info('Syllabus YAML processed: $status');
      if (status) {
        notifyListeners();
        return status;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //Check whether syllabus YAML exists
  Future<String> _getSyllabusPath() async {
    _log.info('_getSyllabusPath method called');
    var appDir = await getApplicationSupportDirectory();
    var syllabusPath = io.File('${appDir.path}/syllabus.yaml');
    var syllabusExists = syllabusPath.existsSync();
    _log.info('syllabusExists: $syllabusExists');
    if (!syllabusExists) {
      // Get user's syllabus URL from userProfile
      final prefs = await SharedPreferences.getInstance();
      var syllabusYamlUrl = prefs.getString('syllabusYamlUrl')!;
      _log.info('Syllabus does not exist locally. Downloading...');
      _log.info('syllabusYamlUrl: $syllabusYamlUrl');
      // Download and rename syllabus yaml as `syllabus.yaml`
      var syllabusYamlPath = await _downloadSyllabus(syllabusYamlUrl);
      _log.info('syllabusYamlPath: $syllabusYamlPath');
      return syllabusYamlPath;
    } else {
      _log.info('Syllabus exists locally at ${syllabusPath.path}');
      return syllabusPath.path;
    }
  }

  // Download syllabus YAML and set proper name
  Future<String> _downloadSyllabus(String url) async {
    _log.info('_downloadSyllabus method called');
    try {
      var saveDir = await getApplicationSupportDirectory();
      String filename = "syllabus.yaml";
      String savePath = "${saveDir.path}/$filename";

      io.File file = io.File(savePath);
      _log.info('Downloading Syllabus to $savePath');
      final httpsReference = FirebaseStorage.instance.refFromURL(url);
      final downloadSyllabus = httpsReference.writeToFile(file);
      await downloadSyllabus.then(
          (p0) => _log.info('Syllabus Download Task Status: ${p0.state.name}'));
      return savePath;
    } catch (e) {
      _log.severe(e.toString());
      rethrow;
    }
  }

  Future<bool> _processSyllabusYaml() async {
    _log.info('_processSyllabusYaml method called');
    var syllabusPath = await _getSyllabusPath();
    _log.info('syllabusPath: $syllabusPath');
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
    _log.info('No. of Semesters loaded: ${semesters.length}');
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
      _log.info('No. of Subjects loaded: ${subjects.length}');
    }
    _syllabus = Syllabus(
      university: university,
      course: course,
      syllabusVersion: syllabusVersion,
      subjects: subjects,
      semesters: semesters,
    );
    _log.info('${syllabus?.semesters.length}');
    notifyListeners();
    return true;
  }

  Future<bool> checkLocalSyllabus() async {
    var appDir = await getApplicationSupportDirectory();
    var syllabusPath = io.File('${appDir.path}/syllabus.yaml');
    var syllabusExists = await syllabusPath.exists();
    _log.info('syllabusExists: $syllabusExists');
    return syllabusExists;
  }

  Future<Syllabus> getSyllabusData() async {
    if (syllabus != null) {
      return syllabus!;
    } else {
      var appDir = await getApplicationSupportDirectory();
      var syllabusPath = io.File('${appDir.path}/syllabus.yaml');
      var syllabusExists = await syllabusPath.exists();
      if (syllabusExists) {
        var processingStatus = await _processSyllabusYaml();
        if (processingStatus && syllabus != null) {
          return syllabus!;
        } else {
          throw Exception('Error processing syllabus...');
        }
      } else {
        throw Exception('Syllabus unavailable locally...');
      }
    }
  }
}
