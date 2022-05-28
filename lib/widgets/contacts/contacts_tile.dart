import 'package:flutter/material.dart';
import 'package:lastpage/models/search_users/search_users_response.dart';

class ContactTile extends StatefulWidget {
  const ContactTile({required this.contact, required this.onTap, Key? key})
      : super(key: key);

  final SearchUsersResponse contact;
  final VoidCallback onTap;

  @override
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  var _selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: widget.contact.avatarUrl != null
                ? NetworkImage(widget.contact.avatarUrl!)
                : null,
            backgroundColor:
                widget.contact.avatarUrl == null ? Colors.blue[200] : null,
            child: widget.contact.avatarUrl == null
                ? Text(
                    widget.contact.name.substring(0, 2).toUpperCase(),
                  )
                : null,
          ),
          title: Text(widget.contact.name),
          trailing: Checkbox(
              value: _selected,
              onChanged: (state) {
                setState(() {
                  _selected = state!;
                  widget.onTap();
                });
              }),
        ),
      ),
    );
  }
}
