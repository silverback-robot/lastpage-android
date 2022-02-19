import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus_data_models/subject_unit.dart';

class ChapterCard extends StatelessWidget {
  const ChapterCard(this.chapter, {Key? key}) : super(key: key);

  final SubjectUnit chapter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Unit ${chapter.unitNumber.toString()}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    if (chapter.title != null)
                      Flexible(
                        child: SizedBox(
                          child: Text(
                            chapter.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                if (chapter.unitContents.isNotEmpty)
                  Wrap(
                      alignment: WrapAlignment.start,
                      children: chapter.unitContents
                          .map(
                            (topic) => Container(
                              margin: const EdgeInsets.all(2.0),
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black54),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Text(topic),
                            ),
                          )
                          .toList()),
              ],
            )),
      ),
    );
  }
}
