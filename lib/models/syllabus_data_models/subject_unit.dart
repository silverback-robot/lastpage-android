class SubjectUnit {
  late int unitNumber;
  String? title;
  List<String> unitContents = [];

  SubjectUnit.fromJson(int unitNo, Map<String, dynamic> json) {
    unitNumber = unitNo;
    title = json['title'];
    unitContents = json['contents'] as List<String>;
  }
}
