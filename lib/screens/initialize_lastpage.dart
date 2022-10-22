import 'package:flutter/material.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:lastpage/screens/dashboard.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';

class InitializeLastpage extends StatelessWidget {
  const InitializeLastpage({Key? key}) : super(key: key);

  static final _log = Logger('InitializeLastpage');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.wait([
            Provider.of<UserProfile>(context).fetchUserProfile(null),
          ]).then((value) {
            _log.info("UserProfile saved. Refreshing Syllabus");
            Provider.of<SyllabusProvider>(context, listen: false)
                .refreshSyllabus();
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              _log.info(
                  "Awaiting completion of method: SyllabusProvider.refreshSyllabus");
              return Center(
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
                ),
              );
            } else if (snapshot.hasError) {
              _log.severe("CANNOT INITIALIZE UserProfile or SyllabusProvider");
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.error_outline_rounded, size: 64),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Something went wrong"),
                  ],
                ),
              );
            }

            _log.info(
                "'SyllabusProvider.refreshSyllabus' has finished. Redirecting to UserDashboard");
            return const UserDashboard();
          }),
    );
  }
}
