import 'dart:io';
import 'package:flutter/material.dart';

import '../models/pages.dart' as pg;

class ScanDoc extends StatefulWidget {
  const ScanDoc({Key? key}) : super(key: key);

  @override
  State<ScanDoc> createState() => _ScanDocState();
}

class _ScanDocState extends State<ScanDoc> {
  final _pages = pg.Pages();

  File? _capturedDocs;
  File? _scannedDoc;

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
                child: _pages.allPages.isNotEmpty
                    ? Image.file(
                        _pages.allPages.first.processed != null
                            ? _pages.allPages.first.processed as File
                            : _pages.allPages.first.original,
                      )
                    : const Text("Click a picture of the note to be saved."),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await _pages.capturePage();
                  setState(() {});
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
