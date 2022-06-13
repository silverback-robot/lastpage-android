import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lastpage/models/user_profile.dart';

import '../widgets/dashboard/dashboard_cards.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: FutureBuilder(
            future: UserProfile.fetchProfile(),
            builder: (context, AsyncSnapshot<UserProfile> snapshot) {
              if ((snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) &&
                  snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    DrawerHeader(
                      child: snapshot.data?.avatar != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                snapshot.data!.avatar!,
                              ),
                            )
                          : const CircleAvatar(
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data?.name! ?? "Your Name",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              snapshot.data?.email ?? "Your Email",
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 200,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                                onPressed: () {
                                  UserProfile.signOut();
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text("Sign Out"))
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(shrinkWrap: true, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardCard(
                    icon: Icons.document_scanner_rounded,
                    title: "Capture a Note",
                    description:
                        "Use your phone's camera to click and upload a note.",
                    onTapAction: () => Navigator.pushNamed(context, '/scanDoc'),
                  ),
                  DashboardCard(
                    icon: Icons.groups,
                    title: "Groups",
                    description:
                        "Upload files from your phone to your account.",
                    onTapAction: () => Navigator.pushNamed(context, '/groups'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardCard(
                    icon: Icons.file_copy_sharp,
                    title: "My Notes",
                    description: "View notes saved in your lastpage account.",
                    onTapAction: () =>
                        Navigator.pushNamed(context, '/my_notes'),
                  ),
                  DashboardCard(
                    icon: Icons.school,
                    title: "My Syllabus",
                    description: "A quick view of your course syllabus.",
                    onTapAction: () =>
                        Navigator.pushNamed(context, '/all_semesters'),
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
