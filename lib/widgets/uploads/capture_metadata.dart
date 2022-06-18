import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/models/syllabus_data_models/syllabus_wrapper.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:provider/provider.dart';

class CaptureMetadata extends StatefulWidget {
  const CaptureMetadata({required this.context, this.groupActivity, Key? key})
      : super(key: key);
  final BuildContext context;
  final GroupActivity? groupActivity;

  @override
  State<CaptureMetadata> createState() => _CaptureMetadataState();
}

class _CaptureMetadataState extends State<CaptureMetadata> {
  late PagesUploadMetadata pagesMetaData;
  bool isSemSelected = false;
  bool isSubjectSelected = false;
  bool isUnitSelected = false;

  int? selectedSem;
  String? selectedSubCode;
  String? subjectTitle;
  int? selectedUnitNo;
  String? title;

  var ignoreGa = false;

  @override
  Widget build(BuildContext context) {
    final userCourse = Provider.of<SyallabusWrapper>(context).course;

    if (!ignoreGa) {
      final ga = widget.groupActivity;
      if (ga != null) {
        selectedSem ??= ga.semesterNo;
        selectedSubCode ??= ga.subjectCode;
        selectedUnitNo ??= ga.unitNo;
        title ??= ga.title ?? "No title";
      }
      if (selectedSem != null &&
          selectedSubCode != null &&
          selectedUnitNo != null) {
        isSemSelected = true;
        isSubjectSelected = true;
        isUnitSelected = true;
      }
    }
    return userCourse != null
        ? Dialog(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      onTap: () {
                        ignoreGa = true;
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedSem = value!;
                          isSemSelected = true;
                          selectedSubCode = null;
                          isSubjectSelected = false;
                          selectedUnitNo = null;
                          isUnitSelected = false;
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
                        onTap: () {
                          ignoreGa = true;
                        },
                        onChanged: (val) {
                          setState(() {
                            selectedSubCode = val;
                            // Horrible; Figure out a better way to handle this!
                            subjectTitle = userCourse.allSemesters
                                .firstWhere((element) =>
                                    element.semesterNumber == selectedSem)
                                .semesterSubjects
                                .firstWhere(
                                  (e) => e.subjectCode == val,
                                )
                                .subjectTitle;
                            isSubjectSelected = true;
                            selectedUnitNo = null;
                            isUnitSelected = false;
                          });
                        }),
                    DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text("Select Unit"),
                        value: selectedUnitNo,
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
                        onTap: () {
                          ignoreGa = true;
                        },
                        onChanged: (val) {
                          setState(() {
                            selectedUnitNo = val;
                            isUnitSelected = true;
                          });
                        }),
                    TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          enabled: true,
                          hintText: title != "No title" ? title : "Title",
                        ),
                        textCapitalization: TextCapitalization.words,
                        autocorrect: true,
                        enabled: true,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                        expands: false,
                        onTap: () {
                          ignoreGa = true;
                        },
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            setState(() {
                              title = val;
                            });
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                      onPressed:
                          isSemSelected && isSubjectSelected && isUnitSelected
                              ? () {
                                  setState(() {
                                    pagesMetaData = PagesUploadMetadata(
                                      semesterNo: selectedSem!,
                                      subjectCode: selectedSubCode!,
                                      subjectTitle: subjectTitle!,
                                      unitNo: selectedUnitNo!,
                                      title: title ?? "No title",
                                    );
                                  });
                                  Navigator.pop(context, pagesMetaData);
                                }
                              : null,
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text("Save & Upload"),
                    )
                  ],
                ),
              ),
            ),
          )
        : Dialog(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Turning pages...")
                    ]),
              ),
            ),
          );
  }
}
