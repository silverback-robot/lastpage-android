import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/auth.dart';
import '../../widgets/dashboard/profile_redirect.dart';

class AuthRedirect extends StatelessWidget {
  AuthRedirect({
    Key? key,
  }) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (BuildContext ctx, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.hasData && userSnapshot.data != null) {
          return const ProfileRedirect();
        }
        return const AuthScreen();
      },
    );
  }
}
