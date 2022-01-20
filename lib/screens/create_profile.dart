import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';
import '../models/university_info.dart';

class CreateProfile extends StatelessWidget {
  CreateProfile({Key? key}) : super(key: key);

  final user = UserProfile(
    name: "Harish",
    university: "Anna University, Chennai",
    department: "EEE",
    avatar: "No Avatar",
  );

  Future<List<DropdownMenuItem<String>>> _populateUnivsDropDown() async {
    var allUnivs = await UniversityInfo.fetchAllUnivs();
    var dropDownItems = allUnivs
        .map(
          (e) => DropdownMenuItem(
            child: Text(e.univName),
            value: e.univName,
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
          builder: (context, dropDownItems) {
            return dropDownItems.hasData
                ? Card(
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
                              TextFormField(
                                key: const ValueKey("university"),
                                decoration: const InputDecoration(
                                  labelText: "University",
                                ),
                                keyboardType: TextInputType.name,
                                // onSaved: (value) {
                                //   _userEmail = value!;
                                // },
                              ),
                              TextFormField(
                                key: const ValueKey("department"),
                                decoration: const InputDecoration(
                                  labelText: "Department",
                                ),
                                keyboardType: TextInputType.name,
                                // onSaved: (value) {
                                //   _userEmail = value!;
                                // },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}
