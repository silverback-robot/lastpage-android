import 'package:firebase_auth/firebase_auth.dart';

class OneOnOneConvo {
  late String convoId;
  late Map<String, dynamic> participants;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  late String oppositeUid;
 

  OneOnOneConvo.fromJson(Map<String, dynamic> json, String docId) {
    convoId = docId;
    participants = json["participants"];
    oppositeUid = participants.keys.where((id) => id !=myUid).first; // Assumes only 2 UIDs exist in the map
  }
}
