import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:lastpage/screens/dashboard.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:lastpage/models/syllabus/syllabus_provider.dart';

class InitializationStatus {
  bool localDataAvailable;
  bool internetAvailable;
  InitializationStatus(
      {required this.localDataAvailable, required this.internetAvailable});
}

class InitializeLastpage extends StatelessWidget {
  const InitializeLastpage({Key? key}) : super(key: key);

  static final _log = Logger('InitializeLastpage');

  Future<bool> checkInternetAccess() async {
    var internetAvailable = await InternetConnectionChecker().hasConnection;
    return internetAvailable;
  }

  Future<void> refreshUserData(BuildContext context) async {
    await Provider.of<UserProfile>(context, listen: false)
        .fetchUserProfile(null);
    _log.info("UserProfile saved. Refreshing Syllabus");
    await Provider.of<SyllabusProvider>(context, listen: false)
        .refreshSyllabus();
  }

  Future<bool> checkLocalData(BuildContext context) async {
    _log.info('Checking local data to continue offline');

    var localProfile = await Provider.of<UserProfile>(context, listen: false)
        .checkLocalProfile();
    _log.info('Local Profile Exists: $localProfile');
    var localSyllabus =
        await Provider.of<SyllabusProvider>(context, listen: false)
            .checkLocalSyllabus();
    _log.info('Local Syllabus Exists: $localSyllabus');

    return localProfile && localSyllabus;
  }

  Future<InitializationStatus> initializeSession(BuildContext context) async {
    var internetStatus = await checkInternetAccess();
    if (internetStatus) {
      _log.info('Internet available. Refreshing profile and syllabus.');
      await refreshUserData(context);
    }
    var localDataStatus = await checkLocalData(context);
    return InitializationStatus(
        localDataAvailable: localDataStatus, internetAvailable: internetStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: initializeSession(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              _log.info("Initializing session...");
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Initializing..."),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              _log.severe("CANNOT INITIALIZE SESSION");
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 64),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("Something went wrong"),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('RETRY')),
                  ],
                ),
              );
            }
            InitializationStatus initializationStatus = snapshot.data;
            _log.info(
                "localDataAvailable: ${initializationStatus.localDataAvailable.toString()} \ninternetAvailable: ${initializationStatus.internetAvailable.toString()}");
            if (initializationStatus.localDataAvailable) {
              return const UserDashboard();
            } else if (!initializationStatus.internetAvailable &&
                !initializationStatus.localDataAvailable) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_outlined, size: 64),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("You are not online."),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('RETRY')),
                  ],
                ),
              );
            } else {
              _log.info(
                  "This is a catch-all. You shouldn't expect to see this in the logs!");
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Still initializing..."),
                  ],
                ),
              );
              ;
            }
          }),
    );
  }
}
