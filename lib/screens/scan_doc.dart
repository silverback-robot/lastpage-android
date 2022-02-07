import 'dart:io';
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
  final _pages = pg.Pages();

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
                        print(pagesModel.allPages.isNotEmpty);
                        return Column(
                          children: pagesModel.allPages
                              .map((page) => PageFrame(
                                    page: page,
                                  ))
                              .toList(),
                        );
                      }
                      return const Text(
                          "Click a picture of a note to be saved.");
                    },
                  )
                  // _pages.allPages.isNotEmpty
                  //     ? Image.file(
                  //         _pages.allPages.first.processed != null
                  //             ? _pages.allPages.first.processed as File
                  //             : _pages.allPages.first.original,
                  //       )
                  //     : const Text("Click a picture of the note to be saved."),
                  ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Provider.of<pg.Pages>(context, listen: false)
                      .capturePage();
                },
                icon: const Icon(
                  Icons.document_scanner,
                ),
                label: const Text(
                  "Capture Document",
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
