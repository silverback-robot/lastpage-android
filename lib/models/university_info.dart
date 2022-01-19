class UniversityInfo {
  String univName;
  String city;
  String state;
  int postcode;
  String website;
  String? syllabusVersion;
  List<String> departments;
  String? customField1;
  String? customField2;
  String? customField3;
  String? customField4;
  String? customField5;

  UniversityInfo(
      {required this.univName,
      required this.city,
      required this.state,
      required this.postcode,
      required this.website,
      required this.departments,
      this.syllabusVersion,
      this.customField1,
      this.customField2,
      this.customField3,
      this.customField4,
      this.customField5});
}
