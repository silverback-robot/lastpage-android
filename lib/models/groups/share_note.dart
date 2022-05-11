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
      await _db
          .collection('userGroups')
          .doc(groupId)
          .collection('activity')
          .add(data);
    } catch (err) {
      rethrow;
    }
  }
}
