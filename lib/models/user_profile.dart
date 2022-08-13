import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends ChangeNotifier {
  final String? name;
  final int? phone;
  final String?
      university; // This should actually be `universityId`. university's documentId is stored here to uniquely identify the university (avoiding ambiguity)
  final String? department;
  final String? syllabusYamlUrl;
  String? avatar;

  final _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;
  FirebaseFirestore get db => _db;

  late String? uid;
  late String? email;

  String? get _uid => _auth.currentUser?.uid;
  String? get _email => _auth.currentUser?.email;

  UserProfile(
      {this.name,
      this.phone,
      this.university,
      this.department,
      this.syllabusYamlUrl}) {
    uid = _uid;
    email = _email;
    fetchUserProfile(uid);
  }

  UserProfile.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        email = json['email'],
        phone = json['phone'],
        name = json['name'],
        university = json['university'],
        department = json['department'],
        syllabusYamlUrl = json['syllabusYamlUrl'],
        avatar = json['avatar'];

  Map<String, dynamic> toJson() => {
        'uid': _uid,
        'email': _email,
        'phone': phone,
        'name': name,
        'university': university,
        'department': department,
        'syllabusYamlUrl': syllabusYamlUrl,
        'avatar': avatar,
      };

  static final FirebaseAuth _fa = FirebaseAuth.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> checkProfile() {
    var _uid = _auth.currentUser!.uid;
    var _profileRef = _db.collection('users').doc(_uid);
    var _profile = _profileRef.snapshots();
    return _profile;
  }

  Future<UserProfile> fetchProfile() async {
    var _profileRef = _db.collection('users').doc(_uid);
    var _profile = await _profileRef.get();
    return UserProfile.fromJson(_profile.data()!);
  }

  Future<String?> uploadAvatar(File avatarPath, BuildContext ctx) async {
    var _uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseStorage avatarBucket = FirebaseStorage.instance;
    Reference ref =
        avatarBucket.ref().child('users').child('avatar_images').child(_uid);
    var uploadTask = ref.putFile(avatarPath);

    try {
      await uploadTask;
      avatar = await ref.getDownloadURL();
      return avatar;
    } on FirebaseException catch (e) {
      var errMsg = "Something went wrong";
      if (e.message != null) {
        errMsg = e.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            errMsg,
          ),
        ),
      );
    } catch (err) {
      var errMsg = "Something went wrong";
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            errMsg,
          ),
        ),
      );
    }
  }

  void saveProfile(BuildContext ctx) async {
    var data = toJson();
    try {
      await _db.collection('users').doc(_uid).set(data);
    } catch (err) {
      var errMsg = "Something went wrong";
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            errMsg,
          ),
        ),
      );
    }
  }

  Future<UserProfile?> fetchUserProfile(String? uid) async {
    var fetchId = uid ?? _uid;
    var profileDoc = await _db.collection('users').doc(fetchId).get();
    if (profileDoc.exists) {
      var userProfile = UserProfile.fromJson(profileDoc.data()!);
      await _saveLocalProfile(userProfile);
      return userProfile;
    }
  }

  static Future<void> signOut() async {
    await _fa.signOut();
  }

  Future<void> _saveLocalProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('uid', profile.uid!);
    await prefs.setString('email', profile.email!);
    await prefs.setInt('phone', profile.phone ?? 0);
    await prefs.setString('name', profile.name ?? "No name");
    await prefs.setString('university', profile.university ?? "UNAVAILABLE");
    await prefs.setString('department', profile.department ?? "UNAVAILABLE");
    await prefs.setString('avatar', profile.avatar ?? "UNAVAILABLE");
    await prefs.setBool('syllabusYamlUrlChanged', false); // initial value

    // update syllabus change flag before updating syllabus URL
    if (prefs.getKeys().contains('syllabusYamlUrl') &&
        prefs.getString('syllabusYamlUrl') != profile.syllabusYamlUrl) {
      await prefs.setBool('syllabusYamlUrlChanged', true);
    } else if (!prefs.getKeys().contains('syllabusYamlUrl')) {
      // First login - sharedPrefs won't contain the key and hence previous condition won't be satisfied
      await prefs.setBool('syllabusYamlUrlChanged', true);
    }
    await prefs.setString(
        'syllabusYamlUrl', profile.syllabusYamlUrl ?? "UNAVAILABLE");
  }
}
