import 'package:flutter/material.dart';

import '../../models/docscanner_models/page.dart' as pg;

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
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.file(
                  _selectEnhanced
                      ? widget.page.processed!
                      : widget.page.original,
                  width: double.infinity,
                ),

                const SizedBox(
                  height: 8,
                ),
                // const SizedBox(height: 12),
                Container(
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withAlpha(0),
                        Colors.black45,
                        Colors.black
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _toggleSelection,
                        icon: Icon(
                          _selectEnhanced
                              ? Icons.toggle_on
                              : Icons.toggle_off_outlined,
                        ),
                        label: Text(
                          _selectEnhanced ? "Enhanced" : "Original",
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => widget.deleteCallback(widget.page.key),
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await widget.page.cropImage();
                          await widget.page.processImg();
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 350,
        child: Image.file(widget.page.original),
      );
    }
  }
}
