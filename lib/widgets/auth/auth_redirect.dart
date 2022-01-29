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
      builder: (ctx, userSnapshot) {
        if (userSnapshot.hasData) {
          return const ProfileRedirect();
        }
        return const AuthScreen();
      },
    );
  }
}
