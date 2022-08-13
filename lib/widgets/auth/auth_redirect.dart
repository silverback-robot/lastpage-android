import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:provider/provider.dart';

import '../../screens/auth.dart';
import '../../widgets/dashboard/profile_redirect.dart';

class AuthRedirect extends StatelessWidget {
  const AuthRedirect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProfile>(context).auth;
    return StreamBuilder(
      stream: auth.authStateChanges(),
      initialData: auth.currentUser,
      builder: (BuildContext ctx, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.hasData && userSnapshot.data != null) {
          return const ProfileRedirect();
        }
        return const AuthScreen();
      },
    );
  }
}
