import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/widgets/my_notes/note_set_tile.dart';
import 'package:provider/provider.dart';

class MyNotes extends StatelessWidget {
  const MyNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Provider.of<UserStorage>(context).userUploads,
          // future: Provider.of<UserStorage>(context).userUploads.first,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Fetching your notes..."),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Oops! Something went wrong..."),
                );
              } else if (snapshot.hasData) {
                List<PagesUploadMetadata> data = snapshot.data;
                var storageDocTiles = data
                    .map(
                      (element) => NotesetTile(notesData: element),
                    )
                    .toList();
                storageDocTiles.sort(
                  (a, b) => b.notesData.createdDateTime
                      .compareTo(a.notesData.createdDateTime),
                );
                return SingleChildScrollView(
                  child: Column(
                    children: storageDocTiles,
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text("You don't have any notes yet..."),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: Text(snapshot.connectionState.toString()),
              );
            }
          }),
    );
  }
}
