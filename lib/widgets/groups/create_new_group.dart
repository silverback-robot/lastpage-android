import 'package:flutter/material.dart';
import 'package:lastpage/models/new_group.dart';
import 'package:lastpage/models/syllabus_data_models/subject.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lastpage/models/syllabus_data_models/syllabus_wrapper.dart';

class CreateNewGroup extends StatefulWidget {
  const CreateNewGroup({required this.context, Key? key}) : super(key: key);

  final BuildContext context;

  @override
  State<CreateNewGroup> createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  late String groupName;
  late NewGroup newGroup;
  String owner = FirebaseAuth.instance.currentUser!.uid;
  bool subjectGroup = false;

  bool isSemSelected = false;
  bool isSubjectSelected = false;

  int? selectedSem;
  String? subjectCode;
  Subject? subject;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userCourse = Provider.of<SyallabusWrapper>(context).course;

    return Form(
      key: _formKey,
      child: Dialog(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Create New Group",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabled: true,
                      hintText: "Group Name",
                    ),
                    textCapitalization: TextCapitalization.words,
                    autocorrect: true,
                    enabled: true,
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    expands: false,
                    maxLength: 30,
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        setState(() {
                          groupName = val;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a valid name';
                      }
                      return null;
                    },
                  ),
                  CheckboxListTile(
                      checkColor: Colors.black,
                      title: const Text("Specific to a subject?"),
                      value: subjectGroup,
                      onChanged: (bool? val) {
                        setState(() {
                          subjectGroup = val!;
                        });
                      }),
                  if (subjectGroup)
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
                      items: userCourse!.allSemesters
                          .map((e) => DropdownMenuItem(
                                child: Text("Semester ${e.semesterNumber}"),
                                value: e.semesterNumber,
                              ))
                          .toList(),
                    ),
                  if (subjectGroup)
                    DropdownButton<Subject>(
                        hint: const Text("Subject"),
                        isExpanded: true,
                        value: subject,
                        items: isSemSelected
                            ? userCourse!.allSemesters
                                .firstWhere((element) =>
                                    element.semesterNumber == selectedSem)
                                .semesterSubjects
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e.subjectTitle,
                                        overflow: TextOverflow.ellipsis),
                                    value: e,
                                  ),
                                )
                                .toList()
                            : null,
                        onChanged: (val) {
                          setState(() {
                            subject = val;
                            isSubjectSelected = true;
                          });
                        }),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                        newGroup = NewGroup(
                            groupName: groupName,
                            owner: owner,
                            subjectGroup: subjectGroup,
                            subject: subject);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Creating your group')),
                        );
                        Navigator.pop(context, newGroup);
                      }
                    },
                    icon: const Icon(Icons.create),
                    label: const Text("Create Group"),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
