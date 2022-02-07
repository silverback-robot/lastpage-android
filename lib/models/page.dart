import 'dart:io';

class Page {
  final File original;
  File? processed;

  Page({
    required this.original,
    this.processed,
  });
}
