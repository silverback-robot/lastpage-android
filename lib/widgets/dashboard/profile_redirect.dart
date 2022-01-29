import 'package:flutter/material.dart';

import '../../screens/dashboard.dart';
import '../../models/user_profile.dart';
import '../../screens/user_profile.dart';

class ProfileRedirect extends StatelessWidget {
  const ProfileRedirect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserProfile.profileExists(),
      builder: (context, userProfileStatus) {
        if (userProfileStatus.hasData) {
          if (userProfileStatus.data == true) {
            return const UserDashboard();
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
