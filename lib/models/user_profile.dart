import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  final String? name;
  final String? university;
  final String? department;
  String? avatar;

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

  static final FirebaseAuth _fa = FirebaseAuth.instance;

  static Future<bool> profileExists() async {
    var _uid = _fa.currentUser!.uid;
    var _profileRef = FirebaseFirestore.instance.collection('users').doc(_uid);
    var _profile = await _profileRef.get();
    return _profile.exists;
  }

  static Future<UserProfile> fetchProfile() async {
    var _uid = _fa.currentUser!.uid;
    var _profileRef = FirebaseFirestore.instance.collection('users').doc(_uid);
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
      return userProfile;
    }
  }

  static Future<void> signOut() async {
    await _fa.signOut();
  }
}
