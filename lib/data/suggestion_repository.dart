import 'package:algolia/algolia.dart';
import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/model/query.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';

/// Query suggestions data repository.
class SuggestionRepository {
  SuggestionRepository._internal();

  static final SuggestionRepository _instance =
      SuggestionRepository._internal();

  factory SuggestionRepository() {
    return _instance;
  }

  final Algolia _algoliaClient = Algolia.init(
      applicationId: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey);

  final List<String> _history = ['jackets'];

  /// Get suggestions for a query.
  Future<List<QuerySuggestion>> getSuggestions(Query query) async {
    AlgoliaQuery algoliaQuery =
        _algoliaClient.instance.index(Credentials.suggestionsIndex);
    algoliaQuery = query.apply(algoliaQuery);
    AlgoliaQuerySnapshot snap = await algoliaQuery.getObjects();
    final hits = snap.toMap()["hits"];
    return List<QuerySuggestion>.from(
        hits.map((hit) => QuerySuggestion.fromJson(hit)));
  }

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
