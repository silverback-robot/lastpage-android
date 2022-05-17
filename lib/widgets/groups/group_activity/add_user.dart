import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({required this.groupId, Key? key}) : super(key: key);

  final String groupId;

  @override
  State<AddUser> createState() => _AddUserState();
}
//TODO: Pass Form Input to SearchUsers Provider and populate below form field

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add users to group"),
      content: ListView(
        shrinkWrap: true,
        children: const [
          TextField(
            enabled: true,
            keyboardType: TextInputType.name,
            enableSuggestions: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("CLOSE"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("ADD USER"),
        ),
      ],
    );
  }
}
