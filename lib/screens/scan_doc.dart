import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pages.dart' as pg;
import '../widgets/pages/page_frame.dart';

class ScanDoc extends StatefulWidget {
  const ScanDoc({Key? key}) : super(key: key);

  @override
  State<ScanDoc> createState() => _ScanDocState();
}

class _ScanDocState extends State<ScanDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(
                  8,
                ),
                child: Consumer<pg.Pages>(
                  builder: (context, pagesModel, child) {
                    if (pagesModel.allPages.isNotEmpty) {
                      return Column(
                        children: pagesModel.allPages
                            .map((page) => PageFrame(
                                  page: page,
                                  deleteCallback: pagesModel.deletePage,
                                  frameKey: UniqueKey(),
                                ))
                            .toList(),
                      );
                    }
                    return const Text("Click a picture of a note to be saved.");
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Provider.of<pg.Pages>(context, listen: false)
                      .capturePage();
                },
                icon: const Icon(
                  Icons.document_scanner,
                ),
                label: Text(
                  Provider.of<pg.Pages>(context).allPages.isNotEmpty
                      ? "Add another page"
                      : "Capture Document",
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // TEMPORARY - Remove after DocScanner integration
        onPressed: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_outlined,
        ),
      ),
    );
  }
}
