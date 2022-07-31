import 'package:flutter/material.dart';
import 'package:lastpage/models/syllabus/subject.dart';

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
                      chapter.unitNumber.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    if (chapter.unitTitle != null)
                      Flexible(
                        child: SizedBox(
                          child: Text(
                            chapter.unitTitle!,
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
                if (chapter.unitContents != null) Text(chapter.unitContents!),
              ],
            )),
      ),
    );
  }
}
