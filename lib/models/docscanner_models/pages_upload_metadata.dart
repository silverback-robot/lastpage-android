import 'package:flutter/material.dart';
import 'dart:convert';

class PagesUploadMetadata {
  int semesterNo;
  String subjectCode;
  int unitNo;
  List<String> downloadUrls = [];
  String setId = UniqueKey().toString();
  int createdDateTime = DateTime.now().millisecondsSinceEpoch;

  PagesUploadMetadata({
    required this.semesterNo,
    required this.subjectCode,
    required this.unitNo,
  });

  PagesUploadMetadata.fromJson(Map<String, dynamic> json)
      : semesterNo = json['semesterNo'],
        subjectCode = json['subjectCode'],
        unitNo = json['unitNo'],
        createdDateTime = int.parse(json['createdDateTime']),
        setId = json['setId'],
        downloadUrls = jsonDecode(json['downloadUrls']);

  Map<String, dynamic> toJson() => {
        'setId': setId,
        'semesterNo': semesterNo,
        'subjectCode': subjectCode,
        'unitNo': unitNo,
        'createdDateTime': createdDateTime.toString(),
        'downloadUrls': downloadUrls,
      };

  Map<String, String> stringKeyVals() => {
        'setId': setId,
        'semesterNo': semesterNo.toString(),
        'subjectCode': subjectCode.toString(),
        'unitNo': unitNo.toString(),
        'createdDateTime': createdDateTime.toString(),
      };
}
