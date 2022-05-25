import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:lastpage/models/search_users/search_users_response.dart';

class LastpageContact {
  Contact contact;
  var lastpageUser = false;
  String? lastpageUid;

  final _db = FirebaseFirestore.instance;
  LastpageContact({
    required this.contact,
  });

  Future<List<Contact>> _fetchDeviceContacts() async {
    var deviceContacts = await ContactsService.getContacts();
    return deviceContacts;
  }

  Future<List<LastpageContact>> _lastpageObjects(
      List<Contact> deviceContacts) async {
    var _lastpageContacts =
        deviceContacts.map((e) => LastpageContact(contact: e)).toList();
    return _lastpageContacts;
  }

  List<int> _contactNumbers(List<LastpageContact> lastpageContacts) {
    // Fetch only phone numbers from all contacts
    final allPhoneNumbers = lastpageContacts.map((e) => e.contact.phones);
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

  _contactsOnLastpage(List<int> deviceContacts) async {
    final _contactsCollection = _db.collection("users");

    // Query Users collection with last 10 digits of each phone number
    var searchRespQS =
        await _contactsCollection.where("phone", whereIn: deviceContacts).get();

    // Parse response and provide UID, Name, Avatar and Phone Number as response
    var contactsOnLastpageJSON = searchRespQS.docs.map((e) => e.data());

    var contactsOnLastpage = contactsOnLastpageJSON
        .map((e) => SearchUsersResponse.fromJson(e))
        .toList();

    // set lastpageUser to true and lastpageUid to Uid returned in search
    // and append to contactsOnLastpage list
  }
}
