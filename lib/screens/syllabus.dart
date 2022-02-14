import 'package:flutter/material.dart';

class ViewSyllabus extends StatelessWidget {
  const ViewSyllabus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed:
              () {}, // TODO: Add SyllabusWrapper to MultiProvider in runApp and call data fetch method on tap to test SyllabusWrapper
          icon: const Icon(Icons.download),
          label: const Text("Fetch Syllabus"),
        ),
      ),
    );
  }
}
