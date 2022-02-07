import 'package:flutter/material.dart';

import '../../models/page.dart' as pg;

class PageFrame extends StatelessWidget {
  const PageFrame({required this.page});

  final pg.Page page;

  @override
  Widget build(BuildContext context) {
    if (page.processed != null) {
      return SizedBox(
        height: 350,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.file(page.original),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.file(page.processed!),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 350,
        child: Image.file(page.original),
      );
    }
  }
}
