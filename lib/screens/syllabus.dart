import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/syllabus_data_models/syllabus_wrapper.dart';

class ViewSyllabus extends StatelessWidget {
  const ViewSyllabus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            await Provider.of<SyallabusWrapper>(context, listen: false)
                .fetchSyllabus();
            var subjects =
                Provider.of<SyallabusWrapper>(context, listen: false).subjects;
            print(
                "${subjects.first.subjectCode}, ${subjects.first.subjectTitle}");
          }, // TODO: Add SyllabusWrapper to MultiProvider in runApp and call data fetch method on tap to test SyllabusWrapper
          icon: const Icon(Icons.download),
          label: const Text("Fetch Syllabus"),
        ),
      ),
    );
  }
}
