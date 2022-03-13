import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/widgets/uploads/upload_info.dart';
import 'package:provider/provider.dart';

class MyNotes extends StatelessWidget {
  const MyNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storageDocs = Provider.of<UserStorage>(context).userStorageDocs;
    return Scaffold(
      body: storageDocs.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: storageDocs
                    .map(
                      (element) => UploadInfo(uploadInfo: element),
                    )
                    .toList(),
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
