import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../screens/dashboard.dart';
import '../../models/user_profile.dart';
import '../../screens/user_profile.dart';

class ProfileRedirect extends StatelessWidget {
  const ProfileRedirect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserProfile.profileExists,
      builder: (context, AsyncSnapshot<DocumentSnapshot> profileSnapshot) {
        if (profileSnapshot.hasData) {
          if (profileSnapshot.data!.exists) {
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
