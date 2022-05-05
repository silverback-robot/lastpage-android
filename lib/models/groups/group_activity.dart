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
  String? fileUploadUrl;
  String? commentAddedText;
  String? userAddedName;
  String? activityId;
  String? groupId;

  GroupActivity.fromJson(Map<String, dynamic> json)
      : activityType = ActivityType.values.byName(json['activityType']),
        activityOwner = json['activityOwner'],
        activityDateTime =
            DateTime.fromMillisecondsSinceEpoch(json['activityDateTime']),
        messagePublishText = json.containsKey('messagePublishText')
            ? json['messagePublishText']
            : null,
        fileUploadUrl =
            json.containsKey('fileUploadUrl') ? json['fileUploadUrl'] : null,
        commentAddedText = json.containsKey('commentAddedText')
            ? json['commentAddedText']
            : null,
        userAddedName =
            json.containsKey('userAddedName') ? json['userAddedName'] : null;

  Map<String, dynamic> toJson() {
    return {
      "activityType": activityType.name,
      "activityOwner": activityOwner,
      "activityDateTime": activityDateTime,
      if (messagePublishText != null) "messagePublishText": messagePublishText,
      if (fileUploadUrl != null) "fileUploadUrl": fileUploadUrl,
      if (commentAddedText != null) "commentAddedText": commentAddedText,
      if (userAddedName != null) "userAddedName": userAddedName,
      if (commentAddedText != null) "commentAddedText": commentAddedText,
    };
  }
}
