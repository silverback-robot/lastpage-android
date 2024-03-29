import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/models/groups/oneonone_convo.dart';

class AllConvos extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _db = FirebaseFirestore.instance;

  Stream<List<OneOnOneConvo>> get allConversations {
    return _db
        .collection('oneOnOne')
        .where("participants.$_uid", isEqualTo: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              var convoInfo = OneOnOneConvo.fromJson(e.data(), e.reference.id);
              return convoInfo;
            },
          ).toList(),
        );
  }

  Stream<List<GroupActivity>> conversation(String convoId) {
    // Reusing GroupActivity widgets and classes (shortcut)
    return _db
        .collection('oneOnOne')
        .doc(convoId)
        .collection('conversation')
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) {
              var conversation = GroupActivity.fromJson(
                e.data(),
              );
              conversation.activityId = e.id;
              conversation.groupId = convoId;
              return conversation;
            },
          ).toList(),
        );
  }

  Future<void> participate(GroupActivity activity) async {
    if (activity.activityType == ActivityType.messagePublish) {
      try {
        await _db
            .collection('oneOnOne')
            .doc(activity.groupId)
            .collection('conversation')
            .add(activity.toJson())
            .then((value) => print(value.path));
      } catch (err) {
        rethrow;
      }
    }
  }
}
