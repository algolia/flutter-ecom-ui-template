import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/data/algolia_client.dart';
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

  final AlgoliaAPIClient _client = AlgoliaAPIClient(
      Credentials.applicationID,
      Credentials.searchOnlyKey,
      Credentials.suggestionsIndex);

  /// Get suggestions for a query.
  Future<List<QuerySuggestion>> getSuggestions(Query query) async {
    final response = await _client.search(query);
    final hits = response["hits"];
    return List<QuerySuggestion>.from(
        hits.map((hit) => QuerySuggestion.fromJson(hit)));
  }
}
