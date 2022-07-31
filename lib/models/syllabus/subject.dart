class Subject {
  String subjectCode;
  String subjectTitle;
  String? LTPC;
  List<SubjectUnit>? subjectUnits = [];

  Subject(
      {required this.subjectCode,
      required this.subjectTitle,
      this.LTPC,
      this.subjectUnits});

  factory Subject.fromJson(Map<String, dynamic> json) {
    var subjectCode = json['subjectCode'] as String;
    var subjectTitle = json['subjectTitle'] as String;
    var rawLTPC = json['LTPC'] as String;
    var LTPC = rawLTPC.replaceAll(' ', '').length == 8
        ? rawLTPC.replaceAll(' ', '')
        : null;
    return Subject(
        subjectCode: subjectCode, subjectTitle: subjectTitle, LTPC: LTPC);
  }
}

class SubjectUnit {
  String unitNumber;
  String? unitTitle;
  String? unitContents;

  SubjectUnit({required this.unitNumber, this.unitTitle, this.unitContents});
}
