import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lastpage/models/docscanner_models/page.dart' as pg;
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';

class Storage extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<String>> uploadPages(
      List<pg.Page> currentSet, PagesUploadMetadata meta) async {
    var metaString = meta.stringKeyVals();
    metaString.addAll({'uid': _uid});

    List<File> uploadSet = [];
    for (var currentPage in currentSet) {
      uploadSet.add(currentPage.processed!);
    }
    print(uploadSet.length);
    print("Calling _uploadNotes...");
    var pageUrls = await _uploadNotes(uploadSet, metaString);
    return pageUrls;
  }

  Future<List<String>> _uploadNotes(
      List<File> noteImg, Map<String, String> userMetadata) async {
    firebase_storage.SettableMetadata firebaseMeta =
        firebase_storage.SettableMetadata(customMetadata: userMetadata);
    List<String> downloadUrls = [];
    for (var img in noteImg) {
      firebase_storage.Reference uploadRef = _storage
          .ref()
          .child("userdata")
          .child(_uid)
          .child("lastpage_${DateTime.now().millisecondsSinceEpoch}");

      var uploadTask = uploadRef.putFile(img, firebaseMeta);
      await uploadTask;
      var pageUrl = await uploadRef.getDownloadURL();
      downloadUrls.add(pageUrl);
    }
    return downloadUrls;
  }

  Future<List<String>> cloneSharedPage(
      List<String> downloadUrls, PagesUploadMetadata? meta) async {
    List<String> clonedUrls = [];
    const limit = 1024 * 1024 * 10;
    for (var url in downloadUrls) {
      final downloadReference = _storage.refFromURL(url);
      final uploadReference = _storage
          .ref()
          .child("userdata")
          .child(_uid)
          .child("lastpage_${DateTime.now().millisecondsSinceEpoch}");

      var firebaseMeta = firebase_storage.SettableMetadata(
          customMetadata: meta?.stringKeyVals());

      try {
        final Uint8List? rawData = await downloadReference.getData(limit);
        if (rawData != null) {
          await uploadReference.putData(rawData, firebaseMeta);
        } else {
          throw Exception("Error downloading raw data from URL: $url");
        }
      } on firebase_storage.FirebaseException catch (err) {
        print("${err.code} :: ${err.message}");
        rethrow;
      } catch (err) {
        print(err.toString());
        rethrow;
      }
      var newUrl = await uploadReference.getDownloadURL();
      clonedUrls.add(newUrl);
    }
    return clonedUrls;
  }
}
