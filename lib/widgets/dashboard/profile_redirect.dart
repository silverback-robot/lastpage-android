import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';
import 'package:lastpage/screens/initialize_lastpage.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../screens/user_profile.dart';

class ProfileRedirect extends StatelessWidget {
  ProfileRedirect({Key? key}) : super(key: key);
  final _log = Logger('ProfileRedirect');

  Future<bool> checkLocalData(BuildContext context) async {
    _log.info('Checking local data to continue offline');

    var localProfile = await Provider.of<UserProfile>(context, listen: false)
        .checkLocalProfile();
    _log.info('Local Profile Exists: $localProfile');
    var localSyllabus =
        await Provider.of<SyllabusProvider>(context, listen: false)
            .checkLocalSyllabus();
    _log.info('Local Syllabus Exists: $localSyllabus');

    return localProfile && localSyllabus;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<UserProfile>(context).checkProfile(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> profileSnapshot) {
        if (profileSnapshot.hasData) {
          if (profileSnapshot.data!.exists) {
            _log.info(
                'User profile verified online. No offline checks done. Proceeding...');
            return const InitializeLastpage();
          } else if (profileSnapshot.connectionState == ConnectionState.done) {
            _log.info('Unable to verify User Profile online.');
            return FutureBuilder(
                future: checkLocalData(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data == true) {
                    _log.info(
                        'Local data available. Proceeding to initialize...');
                    return const InitializeLastpage();
                  } else {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                });
          } else {
            return const CreateProfile();
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
