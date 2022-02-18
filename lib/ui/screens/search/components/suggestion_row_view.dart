import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/highlighted_string.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';

class SuggestionRowView extends StatelessWidget {
  const SuggestionRowView({Key? key, required this.suggestion, this.onPressed})
      : super(key: key);

  final QuerySuggestion suggestion;
  final Function(String)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.search),
      const SizedBox(
        width: 10,
      ),
      _HighlightedTextView(highlighted: suggestion.highlighted!),
      const Spacer(),
      IconButton(
        onPressed: () => onPressed?.call(suggestion.query),
        icon: const Icon(Icons.north_west, color: Colors.grey),
      )
    ]);
  }
}

class _HighlightedTextView extends StatelessWidget {
  const _HighlightedTextView({Key? key, required this.highlighted})
      : super(key: key);

  final String highlighted;

  @override
  Widget build(BuildContext context) {
    List<HighlightedString> strings = [];
    final re = RegExp(r"<em>(\w+)<\/em>");
    final matches = re.allMatches(highlighted).toList();

    void append(String string, bool isHighlighted) {
      strings.add(HighlightedString(string, isHighlighted));
    }

    int prev = 0;
    for (final match in matches) {
      if (prev != match.start) {
        append(highlighted.substring(prev, match.start), false);
      }
      append(match.group(1)!, true);
      prev = match.end;
    }
    if (prev != highlighted.length) {
      append(highlighted.substring(prev), false);
    }

    final spans = strings
        .map((string) => TextSpan(
            text: string.string,
            style: TextStyle(
                fontWeight:
                    string.isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
                fontSize: 15)))
        .toList();

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 15),
        children: spans,
      ),
    );
  }
}
