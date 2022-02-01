import 'dart:io';
// import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Notes {
  final FirebaseAuth _auth = FirebaseAuth.instance;
// TODO: [ENHANCE] Fetch scanner URL and endpoint from DB
  final String _docScannerUrl =
      "https://lastpage-docscanner2-poc-drsfalheva-km.a.run.app";
  final String _docScannerEndPoint = "/v1/docscanner";

  final List<File> allPages = [];
  final List<File> scannedPages = [];

  Future<void> capturePage() async {
    var picker = ImagePicker();
    var capturedDoc = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        preferredCameraDevice: CameraDevice.rear);
    allPages.add(File(capturedDoc!.path));
  }

  Future<void> docScanner(String camImg) async {
    final String _authToken = await _auth.currentUser!.getIdToken();

    final docScannerOut = await http.post(
      Uri.parse(_docScannerUrl + _docScannerEndPoint),
      headers: {HttpHeaders.authorizationHeader: _authToken},
    );

    var uri = Uri.parse(_docScannerUrl + _docScannerEndPoint);
    var request = http.MultipartRequest('POST', uri)
      ..headers[{HttpHeaders.authorizationHeader: _authToken}]
      ..files.add(await http.MultipartFile.fromPath('file', camImg));
    var response = await request.send();

    if (response.statusCode == 200) {
      final Uint8List _scannedDocRaw = docScannerOut.bodyBytes;
      final _scannedDoc =
          await File("docScannerOut_001").writeAsBytes(_scannedDocRaw);
      scannedPages.add(_scannedDoc);
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