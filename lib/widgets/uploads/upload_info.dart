import 'package:flutter/material.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';

class UploadInfo extends StatelessWidget {
  UploadInfo({required this.uploadInfo, Key? key}) : super(key: key);

  PagesUploadMetadata uploadInfo;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(uploadInfo.subjectCode));
  }
}
