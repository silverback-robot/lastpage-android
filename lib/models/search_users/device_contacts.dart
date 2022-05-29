import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastpage/models/search_users/search_users_response.dart';

class LastpageContacts extends ChangeNotifier {
  final List<SearchUsersResponse> _contactsOnLastpage = [];
  List<SearchUsersResponse> get contactsOnLastpage => _contactsOnLastpage;

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  LastpageContacts() {
    refreshContacts();
  }

  Future<List<Contact>> _fetchDeviceContacts() async {
    var deviceContacts = await ContactsService.getContacts();
    return deviceContacts;
  }

  List<String> _contactNumbers(List<Contact> lastpageContacts) {
    // Fetch only phone numbers from all contacts
    final allPhoneNumbers = lastpageContacts.map((e) => e.phones);
    // Remove nulls from list
    final phoneNumbers = allPhoneNumbers.whereType<List<Item>>();
    // Flatten list of lists and remove duplicates
    final cleanListItems = [
      ...{for (var phoneNumberList in phoneNumbers) ...phoneNumberList}
    ];
    // Eliminate less-than-10-digit numbers
    cleanListItems.removeWhere(
        (element) => element.value == null || element.value!.length < 10);

    // Remove all non-numeric characters
    final cleanListCharacters = cleanListItems
        .map((e) => e.value?.replaceAll(RegExp('[^0-9]'), ''))
        .toList();
    // Pick only last 10 digits of Indian mobile numbers
    final cleanListNumbers = cleanListCharacters
        .map((e) => e?.substring(e.length - 10) as String)
        .toList();
    return cleanListNumbers;
  }

  Future<List<SearchUsersResponse>> _fetchLastpageContacts(
      List<String> deviceContacts) async {
    final _contactsCollection = _db.collection("users");
    // Query Users collection with last 10 digits of each phone number
    var searchRespQS =
        await _contactsCollection.where("phone", whereIn: deviceContacts).get();
    // Parse response and provide UID, Name, Avatar and Phone Number as response
    var contactsOnLastpageJSON = searchRespQS.docs.map((e) => e.data());
    var contactsOnLastpage = contactsOnLastpageJSON
        .map((e) => SearchUsersResponse.fromJson(e))
        .toList();
    return contactsOnLastpage;
  }

  Future<void> refreshContacts() async {
    var deviceContacts = await _fetchDeviceContacts();
    var deviceContactPhoneNumbers = _contactNumbers(deviceContacts);
    _contactsOnLastpage.clear();
    for (var i = 0; i < deviceContactPhoneNumbers.length; i += 10) {
      if (deviceContactPhoneNumbers.length - i > 10) {
        _contactsOnLastpage.addAll(await _fetchLastpageContacts(
            deviceContactPhoneNumbers.sublist(i, i + 10)));
      } else {
        _contactsOnLastpage.addAll(await _fetchLastpageContacts(
            deviceContactPhoneNumbers.sublist(
                i, deviceContactPhoneNumbers.length)));
      }
    }
    notifyListeners();
  }

  List<SearchUsersResponse> relevantContacts(List<String?> currentMembers) {
    // Returns device contacts on Lastpage minus logged in user and contacts who are
    // already members of the group

    // Remove logged in user
    final allLastpageMatches = contactsOnLastpage;
    final loggedInUserID = _auth.currentUser!.uid;

    allLastpageMatches.removeWhere((contact) => contact.uid == loggedInUserID);

    // Remove current group members
    for (var member in currentMembers) {
      allLastpageMatches.removeWhere((contact) => contact.uid == member);
    }
    return allLastpageMatches;
  }
}
