import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportPDF {
  static Future<File> exportPDF({required List<String> urls}) async {
    final pdf = pw.Document();
    final List pageProviders = [];

    for (var url in urls) {
      final imgProvider = await networkImage(url);
      pageProviders.add(imgProvider);
    }

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pageProviders
                .map(
                  (e) => pw.Center(
                    child: pw.Image(
                      e,
                      width: double.infinity,
                    ),
                  ),
                )
                .toList(); // Center
          }),
    );

    return _saveDocument(
        name: "lastpage_${DateTime.now().toIso8601String()}.pdf",
        pdf: pdf); // Page
  }

  static Future<File> _saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$name");
    await file.writeAsBytes(bytes);
    return file;
  }
}
