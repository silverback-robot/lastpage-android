import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';
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
  String? selectedUnitNoString;
  String? title;

  var ignoreGa = false;

  @override
  Widget build(BuildContext context) {
    final syllabus = Provider.of<SyllabusProvider>(context).syllabus;

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
    return syllabus != null
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
                      items: syllabus.semesters
                          .map((e) => DropdownMenuItem(
                                child: Text("Semester ${e.semesterNo}"),
                                value: e.semesterNo,
                              ))
                          .toList(),
                    ),
                    DropdownButton<String>(
                        hint: const Text("Subject"),
                        isExpanded: true,
                        value: selectedSubCode,
                        items: isSemSelected
                            ? syllabus.semesters
                                .firstWhere((element) =>
                                    element.semesterNo == selectedSem)
                                .semesterSubjects
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(
                                        syllabus.subjects
                                            .firstWhere((element) =>
                                                element.subjectCode == e)
                                            .subjectTitle,
                                        overflow: TextOverflow.ellipsis),
                                    value: e,
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
                            subjectTitle = syllabus.subjects
                                .firstWhere((element) =>
                                    element.subjectCode == selectedSubCode)
                                .subjectTitle;
                            isSubjectSelected = true;
                            selectedUnitNo = null;
                            isUnitSelected = false;
                          });
                        }),
                    DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Select Unit"),
                        value: selectedUnitNoString,
                        items: isSubjectSelected
                            ? syllabus.subjects
                                .firstWhere((element) =>
                                    element.subjectCode == selectedSubCode)
                                .subjectUnits!
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e.unitNumber,
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
                            selectedUnitNoString = val;
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
                                    selectedUnitNo =
                                        _getUnitNumber(selectedUnitNoString!);
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

// TEMPORARY: Helper to convert unit number strings in syllabus YAML into ints
int _getUnitNumber(String stringUnitNo) {
  late int intUnitNo;
  switch (stringUnitNo.replaceAll(' ', '').toUpperCase()) {
    case ('UNITI'):
      intUnitNo = 1;
      break;
    case ('UNITII'):
      intUnitNo = 2;
      break;
    case ('UNITIII'):
      intUnitNo = 3;
      break;
    case ('UNITIV'):
      intUnitNo = 4;
      break;
    case ('UNITV'):
      intUnitNo = 5;
      break;
    default:
      intUnitNo = 1;
      break;
  }

  return intUnitNo;
}
