class Query {
  String? query;
  List<String>? ruleContexts;

  Query(this.query, {this.ruleContexts});

  String toParams() {
    final Map<String, String?> queryParam = {'query': query, 'ruleContexts': ruleContexts?.join(",")};
    return queryParam.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value ?? '')}').join('&');
  }
}
