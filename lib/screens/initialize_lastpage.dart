import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';

class InitializeLastpage extends StatefulWidget {
  const InitializeLastpage({Key? key}) : super(key: key);

  @override
  State<InitializeLastpage> createState() => _InitializeLastpageState();
}

class _InitializeLastpageState extends State<InitializeLastpage> {
  @override
  void initState() {
    checkSyllabus();
    super.initState();
  }

  void checkSyllabus() async {
    var localSyllabusAvailable =
        await Provider.of<SyllabusProvider>(context).refreshSyllabus();
    if (localSyllabusAvailable) {
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 30,
          ),
          Text("Fetching your syllabus..."),
        ],
      )),
    );
  }
}
