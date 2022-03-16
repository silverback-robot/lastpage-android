import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
// import 'package:lastpage/models/syllabus_data_models/syllabus_wrapper.dart';
import 'package:lastpage/widgets/uploads/upload_info.dart';
import 'package:provider/provider.dart';

class MyNotes extends StatelessWidget {
  const MyNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storageDocs = Provider.of<UserStorage>(context).userStorageDocs;
    // var userSyllabus = Provider.of<SyallabusWrapper>(context).course;
    // var storageSubCodes = storageDocs.map((doc) => doc.subjectCode).toList();
    // for (var subject in storageSubCodes) {
    //   var subjectInfo = userSyllabus.allSemesters.where((element) =>
    //       element.semesterSubjectCodes.where((element) => subject));
    // }
    var storageDocTiles = storageDocs
        .map(
          (element) => UploadInfo(uploadInfo: element),
        )
        .toList();
    storageDocTiles.sort(
      (a, b) =>
          b.uploadInfo.createdDateTime.compareTo(a.uploadInfo.createdDateTime),
    );

    return Scaffold(
      body: storageDocs.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: storageDocTiles,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Fetching your notes..."),
                ],
              ),
            ),
    );
  }
}
