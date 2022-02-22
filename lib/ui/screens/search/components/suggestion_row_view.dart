import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';

import 'highlighted_text_view.dart';

class SuggestionRowView extends StatelessWidget {
  const SuggestionRowView({Key? key, required this.suggestion, this.onComplete})
      : super(key: key);

  final QuerySuggestion suggestion;
  final Function(String)? onComplete;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.search),
      const SizedBox(
        width: 10,
      ),
      HighlightedTextView(
          highlighted: suggestion.highlighted!,
          isInverted: true),
      const Spacer(),
      IconButton(
        onPressed: () => onComplete?.call(suggestion.query),
        icon: const Icon(Icons.north_west),
      )
    ]);
  }
}
