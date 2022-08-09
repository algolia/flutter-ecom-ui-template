import 'dart:async';

import 'package:algolia_helper_flutter/algolia.dart';

import '../credentials.dart';
import '../model/query_suggestion.dart';

class SuggestionSearcher {
  final _searcher = HitsSearcher(
      applicationID: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey,
      indexName: Credentials.suggestionsIndex);

  final List<String> history = ['jackets'];

  Stream<List<QuerySuggestion>> get suggestions =>
      _searcher.responses.map((response) => response.hits
          .map((hit) => QuerySuggestion.fromJson(hit.json))
          .toList());

  void query(String query) {
    _searcher.query(query);
  }

  void addToHistory(String query) {
    if (query.isEmpty) return;
    history.removeWhere((element) => element == query);
    history.add(query);
  }

  void removeFromHistory(String query) {
    history.removeWhere((element) => element == query);
  }

  void clearHistory() {
    history.clear();
  }

  void dispose() {
    _searcher.dispose();
  }
}
