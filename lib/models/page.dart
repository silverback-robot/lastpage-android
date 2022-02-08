import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<bool> cropImage() async {
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
        toolbarTitle: 'Crop & Align Page',
        toolbarColor: Colors.black87,
        toolbarWidgetColor: Colors.blue,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
    );
    if (croppedImg != null) {
      original = croppedImg;
      return true;
    } else {
      return false;
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

  Future<File> _docScanner(String originalImgPath) async {
    // DORMANT: Prefer local image processing over DocScanner2 API call
    const String _docScannerUrl =
        'https://lastpage-docscanner2-poc-drsfalheva-km.a.run.app';
    const String _docScannerEndPoint = '/v1/docscanner';
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Set auth headers and send POST request
    final String _authToken = await _auth.currentUser!.getIdToken();
    var uri = Uri.parse(_docScannerUrl + _docScannerEndPoint);

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      "Authorization": "Bearer $_authToken",
    });
    request.files
        .add(await http.MultipartFile.fromPath('file', originalImgPath));
    var response = await request.send();

    // if (response.statusCode != 200) {
    //   print('DocScanner2 API returned status: ${response.statusCode}');
    // }

    // Handle API response and post-processing

    final _scannedDoc = await _tempFile;
    final Uint8List _scannedDocRaw = await response.stream.toBytes();

    // Convert byte-data into image

    img.Image? _receivedImg = img.decodeImage(_scannedDocRaw);
    if (_receivedImg != null) {
      // Reorient image based on EXIF tags (if available) on decoded image

      _receivedImg = img.bakeOrientation(_receivedImg);

      // Assuming image is always a portrait (paper), rotate image by 90 degrees
      // if height is less than width and write image to temporary file (cache)
      // TODO: [ENHANCE] Allow user to rotate and flip image

      if (_receivedImg.height < _receivedImg.width) {
        _receivedImg = img.copyRotate(_receivedImg, 90);
      }
      _scannedDoc.writeAsBytes(img.encodePng(_receivedImg));
    } else {
      _scannedDoc.writeAsBytes(_scannedDocRaw);
    }
    return _scannedDoc;
  }
}
