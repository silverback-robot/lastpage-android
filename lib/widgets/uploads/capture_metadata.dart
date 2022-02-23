import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus_data_models/semester.dart';
import 'package:lastpage/models/syllabus_data_models/syllabus_wrapper.dart';
import 'package:provider/provider.dart';

class CaptureMetadata extends StatefulWidget {
  const CaptureMetadata({required this.context, Key? key}) : super(key: key);
  final BuildContext context;

  @override
  State<CaptureMetadata> createState() => _CaptureMetadataState();
}

class _CaptureMetadataState extends State<CaptureMetadata> {
  int selectedSem = 1;
  bool isSemSelected = false;
  @override
  Widget build(BuildContext context) {
    final userCourse = Provider.of<SyallabusWrapper>(context).course;
    return userCourse != null
        ? SimpleDialog(
            title: const Text("Where do you want to put these?"),
            children: [
                Row(
                  children: [
                    const Text("Semester"),
                    const SizedBox(
                      width: 12,
                    ),
                    DropdownButton<int>(
                      onChanged: (value) {
                        setState(() {
                          selectedSem = value!;
                          isSemSelected = true;
                        });
                      },
                      value: selectedSem,
                      items: userCourse.allSemesters
                          .map((e) => DropdownMenuItem(
                                child: Text(e.semesterNumber.toString()),
                                value: e.semesterNumber,
                              ))
                          .toList(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Subject"),
                    DropdownButton(
                        items: userCourse.allSemesters
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
                            .toList(),
                        onChanged: (val) {
                          print(val);
                        })
                  ],
                )
              ])
        : const SimpleDialog(
            children: [CircularProgressIndicator(), Text("Getting data...")],
          );
  }
}
