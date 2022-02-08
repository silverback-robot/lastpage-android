import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import './page.dart' as page;

class Pages with ChangeNotifier {
  // Acts as a container for Page objects. Pages class creates Page objects from
  // device camera and stores them in a list which is made available through
  // Provider. Page class stores the actual and enhanced images.

  List<page.Page> allPages = [];

  capturePage() async {
    // Separate try-catch blocks for camera and image processing to allow displaying
    // camera image while image is processed
    File originalPage;
    page.Page newPage;
    try {
      originalPage = await _camCapture();
      newPage = page.Page(original: originalPage, key: UniqueKey());
      await newPage.cropImage();
      allPages.add(newPage);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
    try {
      await newPage.processImg();
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<File> _camCapture() async {
    var picker = ImagePicker();

    var capturedPage = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 75,
    );
    return File(capturedPage!.path);
  }
}
