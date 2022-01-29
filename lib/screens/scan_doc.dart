import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanDoc extends StatelessWidget {
  const ScanDoc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "DocScanner goes here!",
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
