import 'package:flutter/material.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/widgets/my_notes/note_set_tile.dart';

class UploadInfo extends StatelessWidget {
  const UploadInfo({required this.uploadInfo, Key? key}) : super(key: key);

  final PagesUploadMetadata uploadInfo;

  @override
  Widget build(BuildContext context) {
    return NotesetTile(
      title: uploadInfo.title,
      createdDate: uploadInfo.createdDateTime,
      downloadUrls: uploadInfo.downloadUrls,
      noOfPages: uploadInfo.downloadUrls.length,
    );
  }
}
