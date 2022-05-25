import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatefulWidget {
  const ContactTile({required this.contact, Key? key}) : super(key: key);

  final Contact contact;

  @override
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  var _selected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: widget.contact.avatar != null
              ? MemoryImage(widget.contact.avatar!)
              : null,
          backgroundColor:
              widget.contact.avatar == null ? Colors.blue[200] : null,
          child: widget.contact.avatar == null
              ? Text(widget.contact.initials())
              : null,
        ),
        title: Text(widget.contact.displayName ?? widget.contact.givenName!),
        trailing: Checkbox(
            value: _selected,
            onChanged: (state) {
              setState(() {
                _selected = state!;
                //TODO: Add logic to add contact to parent list (parent widget)
              });
            }),
      ),
    );
  }
}
