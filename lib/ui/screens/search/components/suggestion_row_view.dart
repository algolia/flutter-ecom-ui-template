import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../model/query_suggestion.dart';

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
      RichText(
          text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: suggestion.highlighted!.toInlineSpans())),
      const Spacer(),
      IconButton(
        onPressed: () => onComplete?.call(suggestion.query),
        icon: const Icon(Icons.north_west),
      )
    ]);
  }
}
