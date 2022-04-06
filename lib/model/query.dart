import 'package:algolia/algolia.dart';

class Query {
  Query(this.query, {this.ruleContexts, this.page, this.hitsPerPage});

  String? query;
  int? page;
  int? hitsPerPage;
  List<String>? ruleContexts;

  String toParams() {
    final Map<String, String?> queryParam = {
      'query': query,
      'page': page?.toString(),
      'hitsPerPage': hitsPerPage?.toString(),
      'ruleContexts': ruleContexts?.join(","),
    }..removeWhere((key, value) => value == null);
    return queryParam.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value ?? '')}')
        .join('&');
  }

  AlgoliaQuery apply(AlgoliaQuery query) {
    String? queryText = this.query;
    if (queryText != null) {
      query = query.query(queryText);
    }
    int? page = this.page;
    if (page != null) {
      query = query.setPage(page);
    }
    int? hitsPerPage = this.hitsPerPage;
    if (hitsPerPage != null) {
      query = query.setHitsPerPage(hitsPerPage);
    }
    List<String>? ruleContexts = this.ruleContexts;
    if (ruleContexts != null) {
      query = query.setRuleContexts(ruleContexts);
    }
    return query;
  }

  @override
  String toString() {
    return 'Query{query: $query, page: $page, hitsPerPage: $hitsPerPage, ruleContexts: $ruleContexts}';
  }
}
