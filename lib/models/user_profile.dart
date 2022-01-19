import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? name;
  final String? university;
  final String? department;
  final String? avatar;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  late String uid;
  late String email;

  String get _uid => _auth.currentUser!.uid;
  String get _email => _auth.currentUser!.email!;

  UserProfile({
    this.name,
    this.university,
    this.department,
    this.avatar,
  }) {
    uid = _uid;
    email = _email;
  }

  UserProfile.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        email = json['email'],
        name = json['name'],
        university = json['university'],
        department = json['department'],
        avatar = json['avatar'];

  Map<String, dynamic> toJson() => {
        'uid': _uid,
        'email': _email,
        'name': name,
        'university': university,
        'department': department,
        'avatar': avatar,
      };

  static Future<bool> profileExists() async {
    var _uid = FirebaseAuth.instance.currentUser!.uid;
    var _profileRef = FirebaseFirestore.instance.collection('users').doc(_uid);
    var _profile = await _profileRef.get();
    return _profile.exists;
  }

  static Future<UserProfile> fetchProfile() async {
    var _uid = FirebaseAuth.instance.currentUser!.uid;
    var _profileRef = FirebaseFirestore.instance.collection('users').doc(_uid);
    var _profile = await _profileRef.get();
    return UserProfile.fromJson(_profile.data()!);
  }

  void saveProfile() async {
    var data = toJson();
    try {
      await _db.collection('users').doc(_uid).set(data);
    } catch (err) {
      print(err);
    }
  }
}
