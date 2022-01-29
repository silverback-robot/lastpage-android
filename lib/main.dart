import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lastpage/screens/auth.dart';
import 'package:lastpage/screens/dashboard.dart';
import 'package:lastpage/screens/scan_doc.dart';
import 'package:lastpage/screens/user_profile.dart';
import 'firebase_options.dart';

import './widgets/auth/auth_redirect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LastPage',
      theme: ThemeData(
        // TODO: Setup a theme based on lastpage color palette
        primarySwatch: Colors.blueGrey,
      ),
      // home: AuthRedirect(),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthRedirect(),
        'createProfile': (context) => const CreateProfile(),
        'dashboard': (context) => const UserDashboard(),
        'auth': (context) => const AuthScreen(),
        'scanDoc': (context) => const ScanDoc(),
      },
    );
  }
}
