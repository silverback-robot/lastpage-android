import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lastpage/models/cloud_storage_models/storage.dart';
import 'package:lastpage/models/syllabus_data_models/syllabus_wrapper.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/screens/auth.dart';
import 'package:lastpage/screens/dashboard.dart';
import 'package:lastpage/screens/scan_doc.dart';
import 'package:lastpage/screens/all_semesters.dart';
import 'package:lastpage/screens/single_subject.dart';
import 'package:lastpage/screens/user_profile.dart';
import 'package:lastpage/screens/single_semester.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import './widgets/auth/auth_redirect.dart';
import 'models/docscanner_models/pages.dart' as pg;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<pg.Pages>(create: (context) => pg.Pages()),
        ChangeNotifierProvider<SyallabusWrapper>(
            create: (context) => SyallabusWrapper()),
        ChangeNotifierProvider<Storage>(create: (context) => Storage()),
        ChangeNotifierProvider<UserStorage>(create: (context) => UserStorage()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/createProfile': (context) => const CreateProfile(),
        '/dashboard': (context) => const UserDashboard(),
        '/auth': (context) => const AuthScreen(),
        '/scanDoc': (context) => const ScanDoc(),
        '/all_semesters': (context) => const AllSemesters(),
        '/single_semester': (context) => const SingleSemester(),
        '/single_subject': (context) => const SingleSubject(),
      },
    );
  }
}
