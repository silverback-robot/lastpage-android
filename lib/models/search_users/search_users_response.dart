class SearchUsersResponse {
  String uid;
  String name;
  String email;
  String? avatarUrl;
  String universityId;
  String department;

  SearchUsersResponse({
    required this.uid,
    required this.name,
    required this.email,
    required this.universityId,
    required this.department,
    this.avatarUrl,
  });

  SearchUsersResponse.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        avatarUrl = json['avatar'],
        universityId = json['university'],
        department = json['department'];
}
