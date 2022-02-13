// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_profile.dart';

class UserData {
  // final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  getUserSyllabus() async {
    UserProfile userProfile = await UserProfile.fetchProfile();
    var queryUserSubjects = await _db
        .collection("universities")
        .doc(userProfile.university!)
        .collection("departments")
        .where('deptName', isEqualTo: userProfile.department!.toUpperCase())
        .limit(1)
        .get();

    var rawUserSubjects = queryUserSubjects.docs.single.reference.get();
  }
}
