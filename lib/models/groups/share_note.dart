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
      data.addAll({
        'participants': [_uid, recipientUid],
        "activityScope": ActivityScope.groupActivity.name,
      });

      // Search for a document in oneOnOne collection with just the 2 UIDs in participants array
      // If 'exists', use the document ID and post the message below under 'conversation' collection of that doc ID
      // Else, create a new document with 'participants' set to 2 transacting UIDs and then post the message under 'conversation' collection of that doc ID

      await _db
          .collection('oneOnOne')
          .doc(recipientUid)
          .collection('conversation')
          .add(data);
    } catch (err) {
      rethrow;
    }
  }
}
