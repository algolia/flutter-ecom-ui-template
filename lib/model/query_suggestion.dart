class QuerySuggestion {
  QuerySuggestion(this.query, this.highlighted);

  String query;
  String? highlighted;

  static QuerySuggestion fromJson(Map<String, dynamic> json) {
    return QuerySuggestion(
        json["query"], json["_highlightResult"]["query"]["value"]);
  }
}
