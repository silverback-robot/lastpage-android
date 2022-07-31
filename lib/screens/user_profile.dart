import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lastpage/models/lastpage_colors.dart';
import 'dart:io';

import '../models/user_profile.dart';
import '../models/university_info.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  late List<UniversityInfo> _allUnivs;
  List<DepartmentAndSyllabus>? _allDept;
  late String _name;
  late int _phone;
  String? _selectedUniv;
  DepartmentAndSyllabus? _selectedDeptAndSyllabus;
  File? _avatar;

  final _formKey = GlobalKey<FormState>();

  Future<List<DropdownMenuItem<String>>> _populateUnivsDropDown() async {
    _allUnivs = await UniversityInfo.fetchAllUnivs();
    var dropDownItems = _allUnivs
        .map(
          (e) => DropdownMenuItem(
            key: UniqueKey(),
            child: Text(e.univName),
            value: e.documentId,
          ),
        )
        .toList();
    return dropDownItems;
  }

  void _pickAvatar() async {
    var picker = ImagePicker();
    try {
      var pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
        maxWidth: 120,
      );
      setState(() {
        _avatar = File(pickedImage!.path);
      });
    } catch (err) {
      print(err);
    }
  }

  void _submitForm(BuildContext context) async {
    final validForm = _formKey.currentState!.validate();
    String? avatarUrl;

    if (validForm) {
      _formKey.currentState!.save();

      var user = UserProfile(
        name: _name,
        phone: _phone,
        university:
            _selectedUniv, // universityId (Firestore docId) of selected university.
        department: _selectedDeptAndSyllabus?.department,
        syllabusYamlUrl: _selectedDeptAndSyllabus?.syllabusYamlUrl,
        // avatar: avatarUrl
      );
      try {
        if (_avatar != null) {
          avatarUrl = await user.uploadAvatar(_avatar!, context);
          user.avatar = avatarUrl;
        }
        user.saveProfile(context);
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _populateUnivsDropDown(),
          builder: (context,
              AsyncSnapshot<List<DropdownMenuItem<String>>> dropDownItems) {
            if (dropDownItems.hasData &&
                dropDownItems.data != null &&
                dropDownItems.data!.isNotEmpty) {
              return Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 75,
                            backgroundImage:
                                _avatar != null ? FileImage(_avatar!) : null,
                            child: _avatar != null
                                ? null
                                : const Icon(
                                    Icons.account_circle,
                                    color: LastpageColors.lightGrey,
                                    size: 150,
                                  ),
                          ),
                          TextButton.icon(
                            onPressed: _pickAvatar,
                            icon: const Icon(Icons.camera),
                            label: const Text("Add Photo"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              key: const ValueKey("name"),
                              decoration: const InputDecoration(
                                labelText: "Name",
                              ),
                              keyboardType: TextInputType.name,
                              validator: (val) {
                                if (val == null ||
                                    val.length < 4 ||
                                    val.length > 15) {
                                  return "Name must be 4 to 15 characters long";
                                }
                                return null;
                              },
                              onSaved: (val) {
                                _name = val!;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: const Text(
                                    '+91',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    key: const ValueKey("phone"),
                                    decoration: const InputDecoration(
                                      labelText: "Mobile Number",
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (val) {
                                      if (val == null ||
                                          val.length != 10 ||
                                          // Check if val is pure number and invert check result
                                          !val.contains(RegExp(r'^[0-9]+$'))) {
                                        return "Please enter a valid 10-digit number";
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      _phone = int.parse(val!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                              hint: const Text("University"),
                              value: _selectedUniv,
                              items: dropDownItems.data,
                              onChanged: (String? selection) {
                                setState(() {
                                  _selectedUniv = _allUnivs
                                      .firstWhere(
                                        (univ) => univ.documentId == selection,
                                      )
                                      .documentId;
                                  _allDept = _allUnivs
                                      .firstWhere((univ) =>
                                          univ.documentId == selection)
                                      .departmentsAndSyllabus;
                                  _selectedDeptAndSyllabus = null;
                                });
                              },
                              validator: (val) {
                                if (val == null) {
                                  return "Please select your university";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text("Department"),
                              value: _selectedDeptAndSyllabus,
                              items: _allDept
                                  ?.map(
                                    (e) => DropdownMenuItem(
                                      child: Text(
                                        e.department,
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      value: e,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (DepartmentAndSyllabus? selection) {
                                setState(() {
                                  _selectedDeptAndSyllabus = selection;
                                });
                              },
                              validator: (val) {
                                if (val == null) {
                                  return "Please select your department";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _submitForm(context);
                              },
                              child: const Text("Save & Continue!"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
