import 'dart:async';

import 'package:algolia_helper/algolia_helper.dart';

import '../credentials.dart';
import '../model/query_suggestion.dart';

class SuggestionSearcher {
  final AlgoliaHelper _helper = AlgoliaHelper.create(
      applicationID: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey,
      indexName: Credentials.suggestionsIndex);

  final List<String> history = ['jackets'];

  Stream<List<QuerySuggestion>> get suggestions =>
      _helper.responses.map((response) => response.hits
          .map((hit) => QuerySuggestion.fromJson(hit.json))
          .toList());

  void query(String query) {
    _helper.query(query);
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
    _helper.dispose();
  }
}
