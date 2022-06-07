import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lastpage/models/groups/group_activity.dart';

class OneOnOneInteractions extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _db = FirebaseFirestore.instance;

  Stream<List> get allConversations {
    // TODO: Create a Collection Group Index in firebase for 'conversation' sub-collection
    // and return a collection group query

    return _db
        .collection('oneOnOne')
        .where('participants', arrayContains: _uid)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              //TODO: Load into a data class suitable for Contacts Tile

              // var userGroup = UserGroup.fromJson(
              //   e.data(),
              // );
              // userGroup.docId = e.reference.id;
              // return userGroup;
            },
          ).toList(),
        );
  }

  Stream<List<GroupActivity>> conversation(String conversationId) {
    return _db
        .collection('oneOnOne')
        .doc(conversationId)
        .collection('conversation')
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              // TODO: Display One on One activity in a chat window

              var groupActivity = GroupActivity.fromJson(
                e.data(),
              );
              groupActivity.activityId = e.id;
              groupActivity.groupId = conversationId;
              return groupActivity;
            },
          ).toList(),
        );
  }
}
