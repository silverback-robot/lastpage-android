import 'package:flutter/material.dart';
import 'package:lastpage/models/search_users/search_users_response.dart';

class UserSearchResult extends StatelessWidget {
  const UserSearchResult({required this.result, Key? key}) : super(key: key);

  final SearchUsersResponse result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(result.avatarUrl!),
          maxRadius: 20,
        ),
        isThreeLine: true,
        title: Text(result.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.department),
            Text(result.universityId),
          ],
        ),
      ),
    );
  }
}
