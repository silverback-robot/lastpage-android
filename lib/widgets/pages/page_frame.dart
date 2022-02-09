import 'package:flutter/material.dart';

import '../../models/page.dart' as pg;

class PageFrame extends StatefulWidget {
  const PageFrame({
    required this.page,
    required this.deleteCallback,
    required this.frameKey,
  }) : super(key: frameKey);

  final pg.Page page;
  final Function deleteCallback;
  final Key frameKey;

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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(
              onPressed: _toggleSelection,
              icon: Icon(
                _selectEnhanced ? Icons.toggle_on : Icons.toggle_off_outlined,
              ),
              label: Text(
                _selectEnhanced ? "Enhanced" : "Original",
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton.icon(
              onPressed: () => widget.deleteCallback(widget.page.key),
              icon: const Icon(Icons.delete),
              label: const Text("Delete Page"),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await widget.page.cropImage();
                await widget.page.processImg();
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit"),
            ),
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
