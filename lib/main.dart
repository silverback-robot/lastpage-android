import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import './screens/auth.dart';
import './widgets/dashboard/profile_redirect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LastPage',
      theme: ThemeData(
        // TODO: Setup a theme based on lastpage color palette
        primarySwatch: Colors.blueGrey,
      ),
      home: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return ProfileRedirect();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
