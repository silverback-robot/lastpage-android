import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lastpage/models/page.dart';

class Storage extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<String>> uploadPages(List<Page> currentSet) async {
    List<File> uploadSet = [];
    for (var currentPage in currentSet) {
      uploadSet.add(currentPage.processed!);
    }
    print(uploadSet.length);
    print("Calling _uploadNotes...");
    var pageUrls = await _uploadNotes(uploadSet);
    return pageUrls;
  }

  Future<List<String>> _uploadNotes(List<File> noteImg) async {
    List<String> downloadUrls = [];
    for (var img in noteImg) {
      firebase_storage.Reference uploadRef = _storage
          .ref()
          .child("userdata")
          .child(_uid)
          .child("lastpage_${DateTime.now().millisecondsSinceEpoch}");

      var uploadTask = uploadRef.putFile(img);
      await uploadTask;
      var pageUrl = await uploadRef.getDownloadURL();
      downloadUrls.add(pageUrl);
    }
    return downloadUrls;
  }
}
