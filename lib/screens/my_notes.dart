import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/widgets/uploads/upload_info.dart';
import 'package:provider/provider.dart';

class MyNotes extends StatelessWidget {
  const MyNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storageDocs = Provider.of<UserStorage>(context).userStorageDocs;
    return Scaffold(
      body: storageDocs.isNotEmpty
          ? UploadInfo(uploadInfo: storageDocs.first)
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
