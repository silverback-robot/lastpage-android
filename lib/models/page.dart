import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class Page {
// TODO: [ENHANCE] Fetch scanner URL and endpoint from DB
  final String _docScannerUrl =
      'https://lastpage-docscanner2-poc-drsfalheva-km.a.run.app';
  final String _docScannerEndPoint = '/v1/docscanner';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? originalPage;
  File? scannedPage;

  capturePage() async {
    // Separate try-catch blocks for camera and DocScanner to allow displaying
    // camera image in case DocScanner API call fails
    try {
      originalPage = await _camCapture();
    } catch (err) {
      rethrow;
    }
    try {
      scannedPage = await _docScanner(originalPage!.path);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> get _tempPath async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<File> get _tempFile async {
    final path = await _tempPath;
    final uniqueFileName = UniqueKey().toString();

    return File('$path/$uniqueFileName.img');
  }

  Future<File> _camCapture() async {
    var picker = ImagePicker();

    var capturedPage = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 720,
        preferredCameraDevice: CameraDevice.rear);
    return File(capturedPage!.path);
  }

  Future<File> _docScanner(String originalImgPath) async {
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
