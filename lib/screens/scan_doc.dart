import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanDoc extends StatefulWidget {
  const ScanDoc({Key? key}) : super(key: key);

  @override
  State<ScanDoc> createState() => _ScanDocState();
}

class _ScanDocState extends State<ScanDoc> {
  final List<File> _capturedDocs = [];

  void _captureDoc() async {
    var picker = ImagePicker();
    var capturedDoc = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        preferredCameraDevice: CameraDevice.rear);
    setState(() {
      _capturedDocs.add(File(capturedDoc!.path));
    });
  }

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
                child: _capturedDocs.isNotEmpty
                    ? Image.file(_capturedDocs.first)
                    : const Text("Click a picture of the note to be saved."),
              ),
              ElevatedButton.icon(
                onPressed: _captureDoc,
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
