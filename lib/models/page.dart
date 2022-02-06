import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Page {
// TODO: [ENHANCE] Fetch scanner URL and endpoint from DB
  final String _docScannerUrl =
      'https://lastpage-docscanner2-poc-drsfalheva-km.a.run.app';
  final String _docScannerEndPoint = '/v1/docscanner';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? originalPage;
  File? scannedPage;

  capturePage() async {
    try {
      originalPage = await _camCapture();
      scannedPage = await _docScanner(originalPage!.path);
    } catch (err) {
      // TODO: Send error message to UI (toast or SnackBar)
      print(err);
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

    final Uint8List _scannedDocRaw = await response.stream.toBytes();
    final _scannedDoc = await _tempFile;
    _scannedDoc.writeAsBytes(_scannedDocRaw);
    return _scannedDoc;
  }
}
