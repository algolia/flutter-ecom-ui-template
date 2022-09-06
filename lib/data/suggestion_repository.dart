import 'package:flutter/widgets.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';
import 'package:rxdart/rxdart.dart';

/// Query suggestions data repository.
class SuggestionRepository extends ChangeNotifier {
  SuggestionRepository._internal() {
    searchTextController.addListener(() => searchSuggestions(searchTextController.text));
  }

  static final SuggestionRepository _instance =
      SuggestionRepository._internal();

  factory SuggestionRepository() {
    return _instance;
  }

  final searchTextController = TextEditingController();

  final _suggestionSearcher = HitsSearcher(
      applicationID: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey,
      indexName: Credentials.suggestionsIndex);

  final BehaviorSubject<List<String>> _history = BehaviorSubject.seeded(['jackets']);

  void searchSuggestions(String query) {
    _suggestionSearcher.query(query);
  }

  /// Get suggestions for a query.
  Stream<List<QuerySuggestion>> get suggestions =>
      _suggestionSearcher.responses.map((response) {
        return response.hits.map((h) => QuerySuggestion.fromHit(h)).toList();
      });

  Stream<List<String>> get history => _history;

  void addToHistory(String query) {
    if (query.isEmpty) return;
    final _current = _history.value;
    _current.removeWhere((element) => element == query);
    _current.add(query);
    _history.sink.add(_current);
  }

  void removeFromHistory(String query) {
    final _current = _history.value;
    _current.removeWhere((element) => element == query);
    _history.sink.add(_current);
  }

  void completeSuggestion(String suggestion) {
    searchTextController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.fromPosition(
        TextPosition(offset: suggestion.length),
      ),
    );
  }

  void clearHistory() {
    _history.sink.add([]);
  }
}
