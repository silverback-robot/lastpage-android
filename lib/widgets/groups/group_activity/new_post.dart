import 'package:flutter/material.dart';

class NewPost extends StatelessWidget {
  const NewPost({required this.messageText, Key? key}) : super(key: key);

  final String messageText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const Text("User posted a new message"),
        Text(messageText),
      ]),
    );
  }
}
