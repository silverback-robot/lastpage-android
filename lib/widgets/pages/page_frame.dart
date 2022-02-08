import 'package:flutter/material.dart';

import '../../models/page.dart' as pg;

class PageFrame extends StatefulWidget {
  const PageFrame({required this.page});

  final pg.Page page;

  @override
  State<PageFrame> createState() => _PageFrameState();
}

class _PageFrameState extends State<PageFrame> {
  var _selectEnhanced = true;

  void _toggleSelection() => setState(() {
        _selectEnhanced = !_selectEnhanced;
      });

  @override
  Widget build(BuildContext context) {
    if (widget.page.processed != null) {
      return Column(
        children: [
          SizedBox(
            height: 400,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.file(
                _selectEnhanced ? widget.page.processed! : widget.page.original,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            ElevatedButton.icon(
              onPressed: _toggleSelection,
              icon: Icon(
                _selectEnhanced ? Icons.toggle_on : Icons.toggle_off_outlined,
              ),
              label: Text(
                _selectEnhanced ? "Enhanced" : "Original",
              ),
            )
          ]),
        ],
      );
    } else {
      return SizedBox(
        height: 350,
        child: Image.file(widget.page.original),
      );
    }
  }
}
