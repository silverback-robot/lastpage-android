import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:provider/provider.dart';

class MyNotes extends StatelessWidget {
  const MyNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PagesUploadMetadata>>(
          future: Provider.of<UserStorage>(context).fetchUserStorage(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PagesUploadMetadata>> uploadInfoDocs) {
            if (uploadInfoDocs.connectionState == ConnectionState.done &&
                uploadInfoDocs.hasData) {
              print(uploadInfoDocs.data!.first.downloadUrls);
              return Center(
                child: Text(uploadInfoDocs.data!.first.subjectCode),
              );
            } else {
              return Center(
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
              );
            }
          }),
    );
  }
}
