import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastpage/models/new_group.dart';

class AllGroups extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _db = FirebaseFirestore.instance;

  Stream<List<UserGroup>> get participatingGroups {
    return _db
        .collection('userGroups')
        .where('members', arrayContains: _uid)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => UserGroup.fromJson(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}
