import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';

/// Query suggestions data repository.
class SuggestionRepository {
  final searchTextController = TextEditingController();

  final _suggestionsSearcher = HitsSearcher(
    applicationID: Credentials.applicationID,
    apiKey: Credentials.searchOnlyKey,
    indexName: Credentials.suggestionsIndex,
  );

  SuggestionRepository() {
    searchTextController.addListener(() {
      _suggestionsSearcher.query(searchTextController.text);
    });
  }

  /// Get query suggestions stream
  Stream<List<QuerySuggestion>> get suggestions => _suggestionsSearcher
      .responses
      .map((response) => response.hits.map(QuerySuggestion.fromJson).toList());

  /// Replace textController input field with suggestion
  void completeSuggestion(String suggestion) {
    searchTextController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.fromPosition(
        TextPosition(offset: suggestion.length),
      ),
    );
  }
}
