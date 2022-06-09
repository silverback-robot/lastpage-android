import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/models/groups/group_activity.dart';

class ShareNote extends ChangeNotifier {
  PagesUploadMetadata uploadData;
  int activityDateTime = DateTime.now().millisecondsSinceEpoch;
  String? message;
  ActivityType activityType = ActivityType.fileUpload;

  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _db = FirebaseFirestore.instance;

  ShareNote({
    required this.uploadData,
    this.message,
  });

  Map<String, dynamic> _toFirestore() {
    return {
      "activityOwner": _uid,
      "activityDateTime": activityDateTime,
      "fileUploadUrl": uploadData.downloadUrls,
      "title": uploadData.title,
      "subjectCode": uploadData.subjectCode,
      "unitNo": uploadData.unitNo,
      "semesterNo": uploadData.semesterNo,
      "setId": uploadData.setId,
      "activityType": activityType.name,
      if (message != null) "messagePublishText": message,
    };
  }

  Future<void> postInGroup(String groupId) async {
    try {
      var data = _toFirestore();
      data.addAll({
        "activityScope": ActivityScope.groupActivity.name,
      });
      await _db
          .collection('userGroups')
          .doc(groupId)
          .collection('activity')
          .add(data);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> shareNotesWithDeviceContacts(String recipientUid) async {
    try {
      var data = _toFirestore();

      // include participant UIDs for simpler retrieval
      // Ref: https://stackoverflow.com/a/54987884/13297207
      Map<String, dynamic> participants = {
        "participants": {
          _uid: true,
          recipientUid: true,
        },
      };
      data.addAll({
        "activityScope": ActivityScope.oneOnOne.name,
        ...participants,
      });

      var convoRef = _db
          .collection('oneOnOne')
          .where("participants.$_uid", isEqualTo: true)
          .where("participants.$recipientUid", isEqualTo: true);

      var convoDocId = await convoRef.get().then((QuerySnapshot allDocs) {
        if (allDocs.docs.length == 1) {
          return allDocs.docs.first.reference.id;
        }
      });

      if (convoDocId != null) {
        await _db
            .collection('oneOnOne')
            .doc(convoDocId)
            .collection('conversation')
            .add(data);
      } else {
        var convoStarter = await _db.collection('oneOnOne').add(participants);
        await _db
            .collection('oneOnOne')
            .doc(convoStarter.id)
            .collection('conversation')
            .add(data);
      }
    } catch (err) {
      rethrow;
    }
  }
}
