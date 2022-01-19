import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';
import './create_profile.dart';

class UserDashboard extends StatelessWidget {
  UserDashboard({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<bool> checkProfile() async {
    var _profileRef = _db.collection('users').doc(_auth.currentUser!.uid);
    var _profile = await _profileRef.get();
    return _profile.exists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserProfile.profileExists(),
      builder: (context, userProfileStatus) {
        if (userProfileStatus.hasData) {
          if (userProfileStatus.data == true) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("User Dashboard"),
                actions: [
                  IconButton(
                    onPressed: FirebaseAuth.instance.signOut,
                    icon: const Icon(
                      Icons.logout,
                    ),
                  ),
                ],
              ),
              body: const Center(
                // child: Text("Authenticated and Profile Exists!"),
                child: Text("Dashboard"),
              ),
            );
          } else {
            return CreateProfile();
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
