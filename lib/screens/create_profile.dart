import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';
import '../models/university_info.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  late List<UniversityInfo> _allUnivs;
  List<String>? _allDept;
  String? _selectedUniv;
  String? _selectedDept;

  // final user = UserProfile(
  //   name: "Harish",
  //   university: "Anna University, Chennai",
  //   department: "EEE",
  //   avatar: "No Avatar",
  // );

  Future<List<DropdownMenuItem<String>>> _populateUnivsDropDown() async {
    _allUnivs = await UniversityInfo.fetchAllUnivs();
    // _selectedUniv = _allUnivs[0].documentId;
    // _selectedDept = _allUnivs[0].departments[0];
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
                      child: Column(
                        children: [
                          TextFormField(
                            key: const ValueKey("name"),
                            decoration: const InputDecoration(
                              labelText: "Name",
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null ||
                                  value.length < 4 ||
                                  value.length > 12) {
                                return "Name must be 4 to 12 characters long";
                              }
                              return null;
                            },
                            // onSaved: (value) {
                            //   _userEmail = value!;
                            // },
                          ),
                          DropdownButtonFormField(
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
                          ),
                          DropdownButtonFormField(
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
