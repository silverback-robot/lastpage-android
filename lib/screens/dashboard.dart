import 'package:flutter/material.dart';

import '../widgets/dashboard/dashboard_cards.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            DashboardCard(
              icon: Icons.document_scanner_rounded,
              title: "Capture a Note",
              description:
                  "Use your phone's camera to click and upload a note.",
              onTapAction: () {},
            ),
            DashboardCard(
              icon: Icons.upload_file_rounded,
              title: "Upload Notes",
              description: "Upload files from your phone to your account.",
              onTapAction: () {},
            ),
            DashboardCard(
              icon: Icons.file_copy_sharp,
              title: "My Notes",
              description: "View notes saved in your lastpage account.",
              onTapAction: () {},
            ),
            DashboardCard(
              icon: Icons.school,
              title: "My Syllabus",
              description: "A quick view of your course syllabus.",
              onTapAction: () {},
            ),
          ],
        ),
      ),
    );
  }
}
