import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenNotes extends StatelessWidget {
  const FullScreenNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urls = ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: urls.length,
        builder: (ctx, idx) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(urls[idx]),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        loadingBuilder: (context, progress) => const Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
