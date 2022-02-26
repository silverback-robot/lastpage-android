import 'package:flutter/cupertino.dart';

class PagesUploadMetadata {
  int semesterNo;
  String subjectCode;
  int unitNo;
  List<String> tags = [];
  String setId = UniqueKey().toString();

  PagesUploadMetadata(
      {required this.semesterNo,
      required this.subjectCode,
      required this.unitNo,
      tags});

  Map<String, dynamic> toJson() => {
        'setId': setId,
        'semesterNo': semesterNo,
        'subjectCode': subjectCode,
        'unitNo': unitNo,
      };

  Map<String, String> stringKeyVals() => {
        'setId': setId,
        'semesterNo': semesterNo.toString(),
        'subjectCode': subjectCode.toString(),
        'unitNo': unitNo.toString(),
      };
}
