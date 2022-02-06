import 'dart:io';
import 'package:flutter/material.dart';

import '../models/page.dart' as page;

class ScanDoc extends StatefulWidget {
  const ScanDoc({Key? key}) : super(key: key);

  @override
  State<ScanDoc> createState() => _ScanDocState();
}

class _ScanDocState extends State<ScanDoc> {
  final _page = page.Page();

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
                child: _capturedDocs != null
                    ? Image.file(_scannedDoc != null
                        ? _scannedDoc as File
                        : _capturedDocs as File)
                    : const Text("Click a picture of the note to be saved."),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await _page.capturePage();
                  setState(() {
                    _capturedDocs = _page.originalPage;
                    _scannedDoc = _page.scannedPage;
                  });
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
