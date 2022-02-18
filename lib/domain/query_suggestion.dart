
class QuerySuggestion {

  String query;
  String? highlighted;

  QuerySuggestion(this.query, this.highlighted);

  static QuerySuggestion fromJson(Map<String, dynamic> json) {
    return QuerySuggestion(
        json["query"], json["_highlightResult"]["query"]["value"]);
  }

}