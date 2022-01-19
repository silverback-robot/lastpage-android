import 'package:cloud_firestore/cloud_firestore.dart';

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

  UniversityInfo.fromJson(Map<String, dynamic> json)
      : univName = json['univName'],
        city = json['city'],
        state = json['state'],
        postcode = json['postcode'],
        website = json['website'],
        departments = json['departments'],
        syllabusVersion = json['syllabusVersion'],
        customField1 = json['customField1'],
        customField2 = json['customField2'],
        customField3 = json['customField3'],
        customField4 = json['customField4'],
        customField5 = json['customField5'];

  static final FirebaseFirestore _fs = FirebaseFirestore.instance;

  static Future<List<UniversityInfo>> fetchAllUnivs() async {
    var _univCollection = await _fs.collection('universities').get();
    var allUnivs = _univCollection.docs
        .map((e) => UniversityInfo.fromJson(e.data()))
        .toList();
    return allUnivs;
  }
}
