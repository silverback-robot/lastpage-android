import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/models/groups/new_group.dart';
import 'group_activity.dart';

class AllGroups extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _db = FirebaseFirestore.instance;

  Stream<List<UserGroup>> get participatingGroups {
    return _db
        .collection('userGroups')
        .where('members', arrayContains: _uid)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              var userGroup = UserGroup.fromJson(
                e.data(),
              );
              userGroup.docId = e.reference.id;
              return userGroup;
            },
          ).toList(),
        );
  }

  Stream<List<GroupActivity>> groupActivity(String groupId) {
    return _db
        .collection('userGroups')
        .doc(groupId)
        .collection('activity')
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              var groupActivity = GroupActivity.fromJson(
                e.data(),
              );
              groupActivity.activityId = e.id;
              groupActivity.groupId = groupId;
              return groupActivity;
            },
          ).toList(),
        );
  }

  Future<void> participate(GroupActivity activity) async {
    if (activity.activityType == ActivityType.messagePublish) {
      try {
        await _db
            .collection('userGroups')
            .doc(activity.groupId)
            .collection('activity')
            .add(activity.toJson())
            .then((value) => print(value.path));
      } catch (err) {
        rethrow;
      }
    }
  }
}
