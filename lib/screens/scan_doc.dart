import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/storage.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/widgets/uploads/capture_metadata.dart';
import 'package:provider/provider.dart';

import '../models/docscanner_models/pages.dart' as pg;
import '../widgets/pages/page_frame.dart';

class ScanDoc extends StatefulWidget {
  const ScanDoc({Key? key}) : super(key: key);

  @override
  State<ScanDoc> createState() => _ScanDocState();
}

class _ScanDocState extends State<ScanDoc> {
  @override
  Widget build(BuildContext context) {
    final pagesRef = Provider.of<pg.Pages>(context, listen: false);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(
                  8,
                ),
                child: Consumer<pg.Pages>(
                  builder: (context, pagesModel, child) {
                    if (pagesModel.allPages.isNotEmpty) {
                      return Column(
                        children: pagesModel.allPages
                            .map((page) => PageFrame(
                                  page: page,
                                  deleteCallback: pagesModel.deletePage,
                                  frameKey: UniqueKey(),
                                ))
                            .toList(),
                      );
                    }
                    return const Text("Click a picture of a note to be saved.");
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await pagesRef.capturePage();
                },
                icon: const Icon(
                  Icons.document_scanner,
                ),
                label: Text(
                  Provider.of<pg.Pages>(context).allPages.isNotEmpty
                      ? "Add another page"
                      : "Capture Document",
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: pagesRef.allPages.isNotEmpty
          ? FloatingActionButton(
              // TEMPORARY - Remove after DocScanner integration
              onPressed: () async {
                var _notesMetadata = await showDialog<PagesUploadMetadata>(
                    context: context,
                    builder: (BuildContext context) {
                      return CaptureMetadata(context: context);
                    });
                if (_notesMetadata != null) {
                  try {
                    var downloadUrls =
                        await Provider.of<Storage>(context, listen: false)
                            .uploadPages(pagesRef.allPages, _notesMetadata);
                    _notesMetadata.downloadUrls = downloadUrls;
                    await Provider.of<UserStorage>(context, listen: false)
                        .saveCurrentUpload(_notesMetadata);
                    pagesRef.clearAllPages();
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Something went wrong!"),
                      backgroundColor: Colors.red,
                    ));
                  } finally {}
                }
              },
              child: const Icon(
                Icons.save,
              ),
            )
          : null,
    );
  }
}
