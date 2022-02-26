import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus_data_models/syllabus_wrapper.dart';
import 'package:provider/provider.dart';

class CaptureMetadata extends StatefulWidget {
  const CaptureMetadata({required this.context, Key? key}) : super(key: key);
  final BuildContext context;

  @override
  State<CaptureMetadata> createState() => _CaptureMetadataState();
}

class _CaptureMetadataState extends State<CaptureMetadata> {
  bool isSemSelected = false;
  bool isSubjectSelected = false;
  bool isUnitSelected = false;

  int? selectedSem;
  String? selectedSubCode;
  int? selectedUnitNo;

  @override
  Widget build(BuildContext context) {
    final userCourse = Provider.of<SyallabusWrapper>(context).course;
    return userCourse != null
        ? Dialog(
            child: Container(
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Where should this go?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButton<int>(
                    isExpanded: true,
                    hint: const Text("Semester"),
                    onChanged: (value) {
                      setState(() {
                        selectedSem = value!;
                        isSemSelected = true;
                      });
                    },
                    value: selectedSem,
                    items: userCourse.allSemesters
                        .map((e) => DropdownMenuItem(
                              child: Text("Semester ${e.semesterNumber}"),
                              value: e.semesterNumber,
                            ))
                        .toList(),
                  ),
                  DropdownButton<String>(
                      hint: const Text("Subject"),
                      isExpanded: true,
                      value: selectedSubCode,
                      items: isSemSelected
                          ? userCourse.allSemesters
                              .firstWhere((element) =>
                                  element.semesterNumber == selectedSem)
                              .semesterSubjects
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.subjectTitle,
                                      overflow: TextOverflow.ellipsis),
                                  value: e.subjectCode,
                                ),
                              )
                              .toList()
                          : null,
                      onChanged: (val) {
                        setState(() {
                          selectedSubCode = val;
                          isSubjectSelected = true;
                        });
                      }),
                  DropdownButton<int>(
                      isExpanded: true,
                      hint: const Text("Select Unit"),
                      items: isSubjectSelected
                          ? userCourse.allSemesters
                              .firstWhere((element) =>
                                  element.semesterNumber == selectedSem)
                              .semesterSubjects
                              .firstWhere((element) =>
                                  element.subjectCode == selectedSubCode)
                              .units
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.unitNumber.toString(),
                                      overflow: TextOverflow.ellipsis),
                                  value: e.unitNumber,
                                ),
                              )
                              .toList()
                          : null,
                      onChanged: (val) {
                        setState(() {
                          selectedUnitNo = val;
                          isUnitSelected = true;
                        });
                      }),
                ],
              ),
            ),
          )
        : Dialog(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text("Getting data...")
                ]),
          );
  }
}
