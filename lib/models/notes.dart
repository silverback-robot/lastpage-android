import 'dart:io';
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

  Future<void> capturePage() async {
    var picker = ImagePicker();
    var capturedDoc = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        preferredCameraDevice: CameraDevice.rear);
    allPages.add(File(capturedDoc!.path));
  }

  Future<void> docScanner() async {
    final String _authToken = await _auth.currentUser!.getIdToken();

    final docScannerOut = await http.post(
        Uri.parse(_docScannerUrl + _docScannerEndPoint),
        headers: {HttpHeaders.authorizationHeader: _authToken});
    // TODO: Write downloaded image to a file and display on UI
  }
}



// curl -H \
// "Authorization: Bearer $(gcloud auth print-identity-token)" \
// https://lastpage-docscanner2-poc-drsfalheva-km.a.run.app