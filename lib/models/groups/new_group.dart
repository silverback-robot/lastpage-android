import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/models/syllabus_data_models/subject.dart';
import 'package:logging/logging.dart';

class UserGroup {
  String groupName;
  DateTime createdDateTime = DateTime.now();
  String owner;
  List<String> admins = [];
  List<String> members = [];
  bool subjectGroup;
  Subject? subject;
  String? subjectCode;
  String? subjectTitle;
  String? docId;
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  static final _log = Logger("UserGroup");

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
    var groupInfo = toJson();

    try {
      await _db.collection('userGroups').add(groupInfo);
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<void> addMembersToGroup(List<String> selectedUsers) async {
    // Adds a UID to list of members in a group and posts a message in the group
    final activityOwner = _auth.currentUser!.uid;
    final groupDocRef = _db.collection('userGroups').doc(docId);
    final updatedMembers = <String>{...members, ...selectedUsers}.toList();
    try {
      await groupDocRef.update({"members": updatedMembers});

      for (var user in selectedUsers) {
        final activity = GroupActivity(
          activityType: ActivityType.userAdded,
          activityDateTime: DateTime.now(),
          activityOwner: activityOwner,
          groupId: docId,
          userAddedUID: user,
        );
        groupDocRef.collection("activity").add(activity.toJson());
      }
    } catch (err) {
      _log.severe("Error adding user(s) to group.");
      _log.severe(err);
    }
  }
}
