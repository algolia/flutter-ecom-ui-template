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

  @override
  String toString() {
    return 'Query{query: $query, page: $page, hitsPerPage: $hitsPerPage, ruleContexts: $ruleContexts}';
  }
}
