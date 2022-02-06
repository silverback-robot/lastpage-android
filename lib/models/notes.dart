import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Notes {
  final FirebaseAuth _auth = FirebaseAuth.instance;
// TODO: [ENHANCE] Fetch scanner URL and endpoint from DB
  final String _docScannerUrl =
      'https://lastpage-docscanner2-poc-drsfalheva-km.a.run.app';
  final String _docScannerEndPoint = '/v1/docscanner';

  final List<File> allPages = [];
  File? scannedPages;

  Future<String> get _tempPath async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<File> get _tempFile async {
    final path = await _tempPath;
    final uniqueFileName = UniqueKey().toString();

    return File('$path/$uniqueFileName.img');
  }

  Future<void> capturePage() async {
    var picker = ImagePicker();
    var capturedDoc = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        preferredCameraDevice: CameraDevice.rear);
    allPages.add(File(capturedDoc!.path));
    await docScanner(capturedDoc.path);
  }

  Future<void> docScanner(String camImg) async {
    final String _authToken = await _auth.currentUser!.getIdToken();

    // var docScannerOut = await http.get(
    //   Uri.parse('https://lastpage-docscanner2-poc-drsfalheva-km.a.run.app'),
    //   headers: {
    //     'Content-Type': 'application/x-www-form-urlencoded',
    //     HttpHeaders.authorizationHeader: 'Bearer $_authToken',
    //   },
    // );

    var uri = Uri.parse(_docScannerUrl + _docScannerEndPoint);

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      "Authorization": "Bearer $_authToken",
    });
    request.files.add(await http.MultipartFile.fromPath('file', camImg));
    var response = await request.send();

    if (response.statusCode == 200) {
      final Uint8List _scannedDocRaw = await response.stream.toBytes();
      final _scannedDoc = await _tempFile;
      _scannedDoc.writeAsBytes(_scannedDocRaw);
      scannedPages = _scannedDoc;
    } else {
      print(
          'Something went wrong. DocScanner2 API returned status: ${response.statusCode}');
    }

    // final ByteData imageData = await NetworkAssetBundle(
    //         Uri.parse(_docScannerUrl + _docScannerEndPoint))
    //     .load("");

    // final ByteData imageData = (docScannerOut.body);

    // final Uint8List bytes = imageData.buffer.asUint8List();
    // var _tmpDir = await getTemporaryDirectory();
    // final _scannedDocPath = "${_tmpDir.path}/";

    // var _scannedDoc = MemoryImage(bytes);
    // scannedPages.add(File(_scannedDoc));
  }
}



// curl -H \
// "Authorization: Bearer $(gcloud auth print-identity-token)" \
// https://lastpage-docscanner2-poc-drsfalheva-km.a.run.app