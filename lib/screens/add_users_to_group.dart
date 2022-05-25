import 'package:flutter/material.dart';
import 'package:lastpage/widgets/groups/add_new_member/user_search_bar.dart';

class AddUsersToGroup extends StatelessWidget {
  const AddUsersToGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Search Users"),
            const UserSearchBar(),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("BACK"))
          ]),
    );
  }
}
