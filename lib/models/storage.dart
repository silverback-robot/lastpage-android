import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

class Storage {
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<String>> uploadNotes(List<File> noteImg) async {
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
