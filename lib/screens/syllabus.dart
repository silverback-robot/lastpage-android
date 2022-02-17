import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/syllabus_data_models/syllabus_wrapper.dart';

class ViewSyllabus extends StatelessWidget {
  const ViewSyllabus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: Provider.of<SyallabusWrapper>(context).subjects.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(Provider.of<SyallabusWrapper>(context)
                  .subjects[index]
                  .subjectTitle),
            );
          }),
    );
  }
}
