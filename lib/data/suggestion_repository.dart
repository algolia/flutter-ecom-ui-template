import 'package:algolia/algolia.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';

/// Query suggestions data repository.
class SuggestionRepository {
  SuggestionRepository._internal();

  static final SuggestionRepository _instance =
      SuggestionRepository._internal();

  factory SuggestionRepository() {
    return _instance;
  }

  final _suggestionSearcher = HitsSearcher(
      applicationID: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey,
      indexName: Credentials.suggestionsIndex);

  final List<String> _history = ['jackets'];

  void searchSuggestions(String query) {
    _suggestionSearcher.query(query);
  }

  /// Get suggestions for a query.
  Stream<List<QuerySuggestion>> get suggestions =>
      _suggestionSearcher.responses.map((response) {
        return response.hits.map((h) => QuerySuggestion.fromHit(h)).toList();
      });

  List<String> getHistory() {
    return _history;
  }

  void addToHistory(String query) {
    if (query.isEmpty) return;
    _history.removeWhere((element) => element == query);
    _history.add(query);
  }

  void removeFromHistory(String query) {
    _history.removeWhere((element) => element == query);
  }

  void clearHistory() {
    _history.clear();
  }
}
