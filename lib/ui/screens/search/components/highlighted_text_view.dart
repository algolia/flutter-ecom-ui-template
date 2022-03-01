import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/highlighted_string.dart';

class HighlightedTextView extends StatelessWidget {
  final String highlighted;
  final String preTag;
  final String postTag;
  final bool isInverted;
  final TextStyle regularTextStyle;
  final TextStyle highlightedTextStyle;

  const HighlightedTextView(
      {Key? key,
      required this.highlighted,
      this.preTag = "<em>",
      this.postTag = "</em>",
      this.isInverted = false,
      this.regularTextStyle = const TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black87, fontSize: 15),
      this.highlightedTextStyle = const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<HighlightedString> strings = [];
    final re = RegExp("$preTag(\\w+)$postTag");
    final matches = re.allMatches(highlighted).toList();

    void append(String string, bool isHighlighted) {
      strings.add(HighlightedString(string, isHighlighted));
    }

    int prev = 0;
    for (final match in matches) {
      if (prev != match.start) {
        append(highlighted.substring(prev, match.start), isInverted);
      }
      append(match.group(1)!, !isInverted);
      prev = match.end;
    }
    if (prev != highlighted.length) {
      append(highlighted.substring(prev), isInverted);
    }

    final spans = strings
        .map((string) => TextSpan(
            text: string.string,
            style:
                string.isHighlighted ? highlightedTextStyle : regularTextStyle))
        .toList();

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 15),
        children: spans,
      ),
    );
  }
}
