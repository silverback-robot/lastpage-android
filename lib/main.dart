import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lastpage/models/groups/all_groups.dart';
import 'package:lastpage/models/cloud_storage_models/storage.dart';
import 'package:lastpage/models/search_users.dart';
import 'package:lastpage/models/search_users/device_contacts.dart';
import 'package:lastpage/models/syllabus_data_models/syllabus_wrapper.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:lastpage/screens/add_users_to_group.dart';
import 'package:lastpage/screens/all_contacts.dart';
import 'package:lastpage/screens/auth.dart';
import 'package:lastpage/screens/dashboard.dart';
import 'package:lastpage/screens/fullscreen_notes.dart';
import 'package:lastpage/screens/view_group_activity.dart';
import 'package:lastpage/screens/groups.dart';
import 'package:lastpage/screens/my_notes.dart';
import 'package:lastpage/screens/scan_doc.dart';
import 'package:lastpage/screens/all_semesters.dart';
import 'package:lastpage/screens/single_subject.dart';
import 'package:lastpage/screens/user_profile.dart';
import 'package:lastpage/screens/single_semester.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';
import './widgets/auth/auth_redirect.dart';
import 'models/docscanner_models/pages.dart' as pg;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    //TODO: Write logs to file/send for analysis
    print(
        '${record.level.name}: ${record.time}: [${record.loggerName}] ${record.message}');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<pg.Pages>(create: (context) => pg.Pages()),
        ChangeNotifierProvider<SyallabusWrapper>(
            create: (context) => SyallabusWrapper(), lazy: false),
        ChangeNotifierProvider<Storage>(create: (context) => Storage()),
        ChangeNotifierProvider<UserStorage>(create: (context) => UserStorage()),
        ChangeNotifierProvider<AllGroups>(create: (context) => AllGroups()),
        ChangeNotifierProvider<UserProfile>(create: (context) => UserProfile()),
        ChangeNotifierProvider<SearchUsers>(create: (context) => SearchUsers()),
        ChangeNotifierProvider<LastpageContacts>(
            create: (context) => LastpageContacts(), lazy: false),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final _log = Logger('MyApp');

  @override
  Widget build(BuildContext context) {
    _log.info("build method called");

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
        '/my_notes': (context) => const MyNotes(),
        '/fullscreen_notes': (context) => const FullScreenNotes(),
        '/groups': (context) => const Groups(),
        '/group_activity': (context) => const ViewGroupActivity(),
        '/add_user_to_group': (context) => const AddUsersToGroup(),
        '/all_contacts': (context) => AllContacts(),
      },
    );
  }
}
