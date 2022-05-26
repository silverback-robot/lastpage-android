import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:lastpage/models/search_users/search_users_response.dart';

class LastpageContacts extends ChangeNotifier {
  List<SearchUsersResponse> _contactsOnLastpage = [];
  List<SearchUsersResponse> get contactsOnLastpage => _contactsOnLastpage;

  final _db = FirebaseFirestore.instance;

  LastpageContacts() {
    refreshContacts();
  }

  Future<List<Contact>> _fetchDeviceContacts() async {
    var deviceContacts = await ContactsService.getContacts();
    return deviceContacts;
  }

  List<int> _contactNumbers(List<Contact> lastpageContacts) {
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
    // Pick only last 10 digits of Indian mobile numbers
    final cleanListNumbers = cleanListItems
        .map((e) => e.value?.substring(e.value!.length - 10) as int)
        .toList();

    return cleanListNumbers;
  }

  Future<List<SearchUsersResponse>> _fetchLastpageContacts(
      List<int> deviceContacts) async {
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
    _contactsOnLastpage =
        await _fetchLastpageContacts(deviceContactPhoneNumbers);
  }
}
