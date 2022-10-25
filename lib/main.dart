import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lastpage/models/lastpage_colors.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:lastpage/screens/add_users_to_group.dart';
import 'package:lastpage/screens/group_relevant_contacts.dart';
import 'package:lastpage/screens/auth.dart';
import 'package:lastpage/screens/dashboard.dart';
import 'package:lastpage/screens/fullscreen_notes.dart';
import 'package:lastpage/screens/share_notes_individual.dart';
import 'package:lastpage/screens/view_conversation.dart';
import 'package:lastpage/screens/view_group_activity.dart';
import 'package:lastpage/screens/inbox.dart';
import 'package:lastpage/screens/library.dart';
import 'package:lastpage/screens/scan_doc.dart';
import 'package:lastpage/screens/all_semesters.dart';
import 'package:lastpage/screens/single_subject.dart';
import 'package:lastpage/screens/user_profile.dart';
import 'package:lastpage/screens/single_semester.dart';
import 'package:open_file/open_file.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';
import './widgets/auth/auth_redirect.dart';

import 'package:provider/provider.dart';
import 'package:lastpage/models/groups/all_groups.dart';
import 'package:lastpage/models/cloud_storage_models/storage.dart';
import 'package:lastpage/models/groups/all_oneonone_convos.dart';
import 'package:lastpage/models/search_users.dart';
import 'package:lastpage/models/search_users/device_contacts.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/models/docscanner_models/pages.dart' as pg;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Logger
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    //TODO: Write logs to file/send for analysis
    print(
        '${record.level.name}: ${record.time}: [${record.loggerName}] ${record.message}');
  });

  // Initialize Local Notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_name');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: null,
    macOS: null,
    linux: null,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      OpenFile.open(payload);
    }
  });

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final _log = Logger('MyApp');

  @override
  Widget build(BuildContext context) {
    _log.info("build method called");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<pg.Pages>(create: (_) => pg.Pages()),
        ChangeNotifierProvider<SyllabusProvider>(
            create: (_) => SyllabusProvider()),
        ChangeNotifierProvider<Storage>(create: (_) => Storage()),
        ChangeNotifierProvider<UserStorage>(create: (_) => UserStorage()),
        ChangeNotifierProvider<AllGroups>(create: (_) => AllGroups()),
        ChangeNotifierProvider<UserProfile>(create: (_) => UserProfile()),
        ChangeNotifierProvider<SearchUsers>(create: (_) => SearchUsers()),
        ChangeNotifierProvider<LastpageContacts>(
            create: (_) => LastpageContacts()),
        ChangeNotifierProvider<AllConvos>(create: (_) => AllConvos()),
      ],
      child: MaterialApp(
        title: 'LastPage',
        theme: ThemeData(
          // TODO: Setup a theme based on lastpage color palette
          primarySwatch: LastpageColors.white,
          canvasColor: LastpageColors.lightGrey,
          appBarTheme: const AppBarTheme(
            elevation: 1.2,
            backgroundColor: LastpageColors.white,
            iconTheme: IconThemeData(color: LastpageColors.darkGrey),
            titleTextStyle: TextStyle(
                color: LastpageColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          listTileTheme: const ListTileThemeData(
            tileColor: LastpageColors.white,
            iconColor: LastpageColors.darkGrey,
          ),
          shadowColor: LastpageColors.lightGrey,
          primaryColor: LastpageColors.darkGrey,
          colorScheme: ColorScheme.fromSwatch().copyWith(
              // primary: LastpageColors.black,
              secondary: LastpageColors.blue,
              tertiary: LastpageColors.lightGrey),
        ),
        // home: AuthRedirect(),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthRedirect(),
          '/createProfile': (context) => const CreateProfile(),
          '/dashboard': (context) => const UserDashboard(),
          '/auth': (context) => const AuthScreen(),
          '/scanDoc': (context) => const ScanDoc(),
          '/all_semesters': (context) => AllSemesters(),
          '/single_semester': (context) => const SingleSemester(),
          '/single_subject': (context) => const SingleSubject(),
          '/my_notes': (context) => const Library(),
          '/fullscreen_notes': (context) => const FullScreenNotes(),
          '/groups': (context) => const Inbox(),
          '/group_activity': (context) => const ViewGroupActivity(),
          '/add_user_to_group': (context) => const AddUsersToGroup(),
          '/all_contacts': (context) => GroupRelevantContacts(),
          '/share_notes_individual': (context) => const ShareNotesIndividual(),
          '/view_conversation': (context) => const ViewConversation(),
        },
      ),
    );
  }
}
