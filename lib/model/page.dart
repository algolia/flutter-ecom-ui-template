import 'package:algolia_helper_flutter/algolia.dart';

class Page<T> {
  Page(this.data, this.isLastPage, this.nextPageKey, this.nbHits);

  factory Page.from(SearchResponse response, T Function(Hit hit) deserializer) {
    final hits = response.hits;
    final isLastPage = response.page == response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    final data = hits.map((hit) => deserializer(hit)).toList();
    return Page(data, isLastPage, nextPageKey, response.nbHits);
  }

  final List<T> data;
  final bool isLastPage;
  final int? nextPageKey;
  final int nbHits; // total nb of hits
}
