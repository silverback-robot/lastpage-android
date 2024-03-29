import 'package:flutter/material.dart';

class PagesUploadMetadata {
  late int semesterNo;
  late String subjectCode;
  late String subjectTitle;
  late int unitNo;
  late String title;
  List<String> downloadUrls = [];
  String setId = UniqueKey().toString();
  int createdDateTime = DateTime.now().millisecondsSinceEpoch;

  PagesUploadMetadata({
    required this.semesterNo,
    required this.subjectCode,
    required this.subjectTitle,
    required this.unitNo,
    this.title = "No title",
  });

  PagesUploadMetadata.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "No title";
    semesterNo = json['semesterNo'];
    subjectCode = json['subjectCode'];
    subjectTitle = json['subjectTitle'] ?? "No title";
    unitNo = json['unitNo'];
    createdDateTime = int.parse(json['createdDateTime']);
    setId = json['setId'];
    downloadUrls =
        (json['downloadUrls'] as List).map((url) => url as String).toList();
  }

  Map<String, dynamic> toJson() => {
        'setId': setId,
        'semesterNo': semesterNo,
        'subjectCode': subjectCode,
        'subjectTitle': subjectTitle,
        'unitNo': unitNo,
        'title': title,
        'createdDateTime': createdDateTime.toString(),
        'downloadUrls': downloadUrls,
      };

  Map<String, String> stringKeyVals() => {
        'setId': setId,
        'semesterNo': semesterNo.toString(),
        'subjectCode': subjectCode.toString(),
        'subjectTitle': subjectTitle.toString(),
        'unitNo': unitNo.toString(),
        'createdDateTime': createdDateTime.toString(),
      };
}
