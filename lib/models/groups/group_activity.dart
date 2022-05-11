enum ActivityType {
  fileUpload,
  messagePublish,
  commentAdded,
  userAdded,
}

class GroupActivity {
  late ActivityType activityType;
  late String activityOwner;
  late DateTime activityDateTime;
  String? messagePublishText;
  List<String>? fileUploadUrl;
  String? commentAddedText;
  String? userAddedName;
  String? activityId;
  String? groupId;
  int? semesterNo;
  String? subjectCode;
  int? unitNo;
  String? title;

  GroupActivity({
    required this.activityType,
    required this.activityOwner,
    required this.activityDateTime,
    this.groupId,
    this.messagePublishText,
    this.fileUploadUrl,
    this.userAddedName,
    this.semesterNo,
    this.subjectCode,
    this.unitNo,
    this.title,
  });

  GroupActivity.fromJson(Map<String, dynamic> json)
      : activityType = ActivityType.values.byName(json['activityType']),
        activityOwner = json['activityOwner'],
        activityDateTime =
            DateTime.fromMillisecondsSinceEpoch(json['activityDateTime']),
        messagePublishText = json.containsKey('messagePublishText')
            ? json['messagePublishText']
            : null,
        fileUploadUrl = json.containsKey('fileUploadUrl')
            ? json['fileUploadUrl'].cast<String>()
            : null,
        commentAddedText = json.containsKey('commentAddedText')
            ? json['commentAddedText']
            : null,
        userAddedName =
            json.containsKey('userAddedName') ? json['userAddedName'] : null,
        semesterNo = json.containsKey('semesterNo') ? json['semesterNo'] : null,
        subjectCode =
            json.containsKey('subjectCode') ? json['subjectCode'] : null,
        unitNo = json.containsKey('unitNo') ? json['unitNo'] : null,
        title = json.containsKey('title') ? json['title'] : null;

  Map<String, dynamic> toJson() {
    return {
      "activityType": activityType.name,
      "activityOwner": activityOwner,
      "activityDateTime": activityDateTime.millisecondsSinceEpoch,
      if (messagePublishText != null) "messagePublishText": messagePublishText,
      if (fileUploadUrl != null) "fileUploadUrl": fileUploadUrl,
      if (commentAddedText != null) "commentAddedText": commentAddedText,
      if (userAddedName != null) "userAddedName": userAddedName,
      if (commentAddedText != null) "commentAddedText": commentAddedText,
    };
  }
}
