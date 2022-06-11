import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/models/groups/oneonone_convo.dart';


class AllConvos extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _db = FirebaseFirestore.instance;

  Stream<List<OneOnOneConvo>> get participatingGroups {
    return _db
        .collection('oneOnOne')
        .where("participants.$_uid", isEqualTo: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              var convoInfo = OneOnOneConvo.fromJson(
                e.data(),
              e.reference.id
              );
              return convoInfo;
            },
          ).toList(),
        );
  }

  Stream<List<GroupActivity>> groupActivity(String convoId) {
    // Reusing GroupActivity widgets and classes (shortcut)
    return _db
        .collection('oneOnOne')
        .doc(convoId)
        .collection('activity')
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              var groupActivity = GroupActivity.fromJson(
                e.data(),
              );
              groupActivity.activityId = e.id;
              groupActivity.groupId = convoId;
              return groupActivity;
            },
          ).toList(),
        );
  }

  // TODO: Rework 'participate' method for one-on-one conversations
  // Future<void> participate(GroupActivity activity) async {
  //   if (activity.activityType == ActivityType.messagePublish) {
  //     try {
  //       await _db
  //           .collection('userGroups')
  //           .doc(activity.groupId)
  //           .collection('activity')
  //           .add(activity.toJson())
  //           .then((value) => print(value.path));
  //     } catch (err) {
  //       rethrow;
  //     }
  //   }
  // }
}
