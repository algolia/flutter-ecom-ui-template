import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

class SearchMetadata {
  final String query;
  final int nbHits;

  const SearchMetadata(this.query, this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) =>
      SearchMetadata(response.query, response.nbHits);

  @override
  String toString() {
    return 'SearchMetadata{query: $query, nbHits: $nbHits}';
  }
}
