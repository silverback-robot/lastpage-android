import 'package:flutter/foundation.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStorage extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _db = FirebaseFirestore.instance;

  fetchUserStorage() async {
    var userStorageQS =
        await _db.collection('users').doc(_uid).collection('uploads').get();
    var userStorageDocs = userStorageQS.docs
        .map((e) => PagesUploadMetadata.fromJson(e.data()))
        .toList();
  }

  saveCurrentUpload(PagesUploadMetadata uploadMetadata) async {
    try {
      await _db
          .collection('users')
          .doc(_uid)
          .collection('uploads')
          .add(uploadMetadata.toJson());
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }
}
