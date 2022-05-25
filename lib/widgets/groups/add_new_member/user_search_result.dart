import 'package:flutter/material.dart';
import 'package:lastpage/models/search_users/search_users_response.dart';

class UserSearchResult extends StatelessWidget {
  const UserSearchResult(
      {required this.result, required this.onTapCallback, Key? key})
      : super(key: key);

  final SearchUsersResponse result;
  final VoidCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(result.avatarUrl!, fit: BoxFit.contain),
          ),
        ),
        isThreeLine: true,
        title: Text(result.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.department,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              result.universityId,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: onTapCallback,
      ),
    );
  }
}
