import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
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
  List<String>? _allDept;
  late String _name;
  String? _selectedUniv;
  String? _selectedDept;
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
        university: _selectedUniv,
        department: _selectedDept,
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
        title: const Text("User Profile"),
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
            if (dropDownItems.hasData) {
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
                            radius: 60,
                            backgroundImage:
                                _avatar != null ? FileImage(_avatar!) : null,
                          ),
                          TextButton.icon(
                            onPressed: _pickAvatar,
                            icon: const Icon(Icons.camera),
                            label: const Text("Add Photo"),
                          ),
                          TextFormField(
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
                          DropdownButtonFormField(
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
                                    .firstWhere(
                                        (univ) => univ.documentId == selection)
                                    .departments;
                              });
                            },
                            validator: (val) {
                              if (val == null) {
                                return "Please select your university";
                              }
                              return null;
                            },
                          ),
                          DropdownButtonFormField(
                            hint: const Text("Department"),
                            value: _selectedDept,
                            items: _allDept
                                ?.map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (String? selection) {
                              setState(() {
                                _selectedDept = selection;
                              });
                            },
                            validator: (val) {
                              if (val == null) {
                                return "Please select your department";
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _submitForm(context);
                            },
                            child: const Text("Save Profile"),
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
