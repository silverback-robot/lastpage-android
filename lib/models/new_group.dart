import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lastpage/models/syllabus_data_models/subject.dart';

class NewGroup {
  String groupName;
  DateTime createdDateTime = DateTime.now();
  String owner;
  bool subjectGroup;
  Subject? subject;
  List<String?> members = [];

  NewGroup(
      {required this.groupName,
      required this.owner,
      required this.subjectGroup,
      this.subject});

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
        'subject': subjectGroup ? subject?.subjectTitle : null,
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
