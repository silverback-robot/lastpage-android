import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class Page {
  File original;
  File? processed;
  Key key;

  Page({
    required this.original,
    this.processed,
    required this.key,
  });

  Future<String> get _tempPath async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<File> get _tempFile async {
    final path = await _tempPath;
    final uniqueFileName = UniqueKey().toString();

    return File('$path/$uniqueFileName.img');
  }

  Future<void> cropImage() async {
    File? croppedImg = await ImageCropper.cropImage(
      sourcePath: original.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black87,
          toolbarWidgetColor: Colors.blue,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    if (croppedImg != null) {
      original = croppedImg;
    }
  }

  Future<void> processImg() async {
    final _processedImg = await _tempFile;
    var decodedImg = img.decodeImage(
      await original.readAsBytes(),
    );
    if (decodedImg != null) {
      img.brightness(decodedImg, 32);
      img.grayscale(decodedImg);
      img.contrast(decodedImg, 120);
      var sepiaImg = img.sepia(decodedImg, amount: 0.2);
      _processedImg.writeAsBytes(img.encodePng(sepiaImg, level: 4));
      processed = _processedImg;
    }
  }
}
