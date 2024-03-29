import 'package:flutter/material.dart';
import 'package:lastpage/models/cloud_storage_models/storage.dart';
import 'package:lastpage/models/cloud_storage_models/user_storage.dart';
import 'package:lastpage/models/docscanner_models/pages_upload_metadata.dart';
import 'package:lastpage/models/groups/group_activity.dart';
import 'package:lastpage/widgets/uploads/capture_metadata.dart';
import 'package:provider/provider.dart';

class DisplayFileUpload extends StatelessWidget {
  const DisplayFileUpload({required this.groupActivity, Key? key})
      : super(key: key);

  final GroupActivity groupActivity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: Row(
        children: [
          Image.network(
            groupActivity.fileUploadUrl![0],
            height: 150,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupActivity.title ?? "[No title]",
                      maxLines: 3,
                      // softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      groupActivity.messagePublishText ??
                          "${groupActivity.fileUploadUrl!.length} pages",
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    groupActivity.unitNo != null
                        ? Text(
                            "Unit ${groupActivity.unitNo.toString()}",
                            style: const TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 6,
                    ),
                    if (groupActivity.subjectCode != null)
                      Text(
                        "${groupActivity.subjectCode} | ${groupActivity.subjectTitle ?? "No title"}",
                        style: const TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, '/fullscreen_notes',
                              arguments: groupActivity.fileUploadUrl),
                          icon: const Icon(Icons.fullscreen_rounded),
                          label: const Text("VIEW"),
                          style: OutlinedButton.styleFrom(
                              fixedSize: const Size(100, 15)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            var _notesMetadata =
                                await showDialog<PagesUploadMetadata>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CaptureMetadata(
                                        context: context,
                                        groupActivity: groupActivity,
                                      );
                                    });
                            if (_notesMetadata != null) {
                              try {
                                var downloadUrls = await Provider.of<Storage>(
                                        context,
                                        listen: false)
                                    .cloneSharedPage(
                                        groupActivity.fileUploadUrl!,
                                        _notesMetadata);
                                _notesMetadata.downloadUrls = downloadUrls;
                                await Provider.of<UserStorage>(context,
                                        listen: false)
                                    .saveCurrentUpload(_notesMetadata);
                              } catch (err) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Something went wrong!"),
                                  backgroundColor: Colors.red,
                                ));
                              } finally {}
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text("SAVE"),
                          style: OutlinedButton.styleFrom(
                              fixedSize: const Size(100, 15)),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
