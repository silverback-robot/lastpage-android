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
}
