import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lastpage/models/lastpage_colors.dart';
import 'package:lastpage/models/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/dashboard/dashboard_cards.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final privacyPolicy =
        Uri(scheme: "https", host: "lastpage.app", path: "privacy_policy.html");
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          "assets/logo/lastpage_logo.svg",
          width: 150,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: FutureBuilder(
            future: Provider.of<UserProfile>(context).fetchProfile(),
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
                                onPressed: () async {
                                  await Provider.of<UserProfile>(context,
                                          listen: false)
                                      .signOut();
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text("Sign Out")),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "\u00a9 Lastpage Student Services.",
                                  style: TextStyle(
                                    color: LastpageColors.darkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await launchUrl(privacyPolicy);
                                  },
                                  child: const Text(
                                    "Privacy policy.",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardCard(
                    icon: Icons.document_scanner_rounded,
                    title: "Scanner",
                    description: "Opens the camera to capture notes.",
                    onTapAction: () => Navigator.pushNamed(context, '/scanDoc'),
                  ),
                  DashboardCard(
                    icon: Icons.message_rounded,
                    title: "Inbox",
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
                    title: "Library",
                    description: "View notes saved in your lastpage account.",
                    onTapAction: () =>
                        Navigator.pushNamed(context, '/my_notes'),
                  ),
                  DashboardCard(
                    icon: Icons.school,
                    title: "Syllabus",
                    description: "A quick view of your course syllabus.",
                    onTapAction: () =>
                        Navigator.pushNamed(context, '/all_semesters'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
