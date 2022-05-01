import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lastpage/models/syllabus_data_models/subject.dart';

class UserGroup {
  String groupName;
  DateTime createdDateTime = DateTime.now();
  String owner;
  List<String> admins = [];
  List<String?> members = [];
  bool subjectGroup;
  Subject? subject;
  String? subjectCode;
  String? subjectTitle;
  String? docId;

  UserGroup(
      {required this.groupName,
      required this.owner,
      required this.subjectGroup,
      this.subject});

  UserGroup.fromJson(Map<String, dynamic> json)
      : groupName = json['groupName'],
        owner = json['owner'],
        admins = (json['admins'] as List<dynamic>).cast<String>(),
        members = (json['members'] as List<dynamic>).cast<String>(),
        subjectGroup = json['subjectGroup'],
        subjectCode = json['subjectCode'],
        subjectTitle = json['subjectTitle'];

  Map<String, dynamic> toJson() => {
        'groupName': groupName,
        'createdDateTime': createdDateTime.millisecondsSinceEpoch,
        'owner': owner,
        'members': members..add(owner),
        'admins': [
          owner,
        ],
        'subjectGroup': subjectGroup,
        'subjectCode': subjectGroup ? subject?.subjectCode : null,
        'subjectTitle': subjectGroup ? subject?.subjectTitle : null,
      };

  Future<void> createNewGroup() async {
    final _db = FirebaseFirestore.instance;
    var groupInfo = toJson();

    try {
      await _db.collection('userGroups').add(groupInfo);
    } catch (err) {
      print(err);
      rethrow;
    }
  }
}
