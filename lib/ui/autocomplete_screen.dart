import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/algolia_client.dart';
import 'package:flutter_ecom_demo/domain/query.dart';
import 'package:flutter_ecom_demo/ui/search_results_screen.dart';

class QuerySuggestion {
  String query;
  String? highlighted;

  QuerySuggestion(this.query, this.highlighted);

  static QuerySuggestion fromJson(Map<String, dynamic> json) {
    return QuerySuggestion(
        json["query"], json["_highlightResult"]["query"]["value"]);
  }

  static RichText fromHighlighted(String highlighted) {
    // RegExp exp = new RegExp(r"(\w+)");
    // String str = "Parse my string";
    // Iterable<RegExpMatch> matches = exp.allMatches(str);
    List<TextSpan> textSpans = [];
    var re = RegExp(r"<em>(\w+)<\/em>");
    var matches = highlighted.allMatches(highlighted);
    var output = matches.map((e) => e.group(1));
    print("${highlighted}: ${output}");
    return RichText(
        text: TextSpan(
            text: highlighted,
            style: TextStyle(color: Colors.black87, fontSize: 15)));
    return RichText(
      text: TextSpan(
        text: 'Hello ',
        style: TextStyle(color: Colors.black87, fontSize: 15),
        children: const <TextSpan>[
          TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' world!'),
        ],
      ),
    );
    // return Text(highlighted);
  }
}

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {
  var algoliaClient = AlgoliaAPIClient(
      "latency",
      "927c3fe76d4b52c5a2912973f35a3077",
      "STAGING_native_ecom_demo_products_query_suggestions");
  var searchTextController = TextEditingController();

  List<String> _history = ['jackets'];
  List<QuerySuggestion> _suggestions = [];

  void _didChangeSearchText() {
    final queryString = searchTextController.text;
    final query = Query(queryString);
    algoliaClient.search(query).then((value) => _handleResponse(value));
  }

  void _handleResponse(Map<dynamic, dynamic> response) {
    final hits = response["hits"];
    final receivedSuggestions = List<QuerySuggestion>.from(
        hits.map((hit) => QuerySuggestion.fromJson(hit)));
    setState(() {
      _suggestions = receivedSuggestions;
    });
  }

  void _didSubmitSearch(String query) {
    _addToHistory(query);
    _launchSearch(query);
  }

  void _addToHistory(String query) {
    if (query.isEmpty) {
      return;
    }
    _history.removeWhere((element) => element == query);
    setState(() {
      _history.add(query);
    });
  }

  void _removeFromHistory(String query) {
    setState(() {
      _history.removeWhere((element) => element == query);
    });
  }

  void _completeSuggestion(String suggestion) {
    searchTextController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.fromPosition(
        TextPosition(offset: suggestion.length),
      ),
    );
  }

  void _launchSearch(String query) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return SearchResultsScreen(query: query);
      },
    ));
  }

  Widget _header() {
    var primaryColor = Color(0xFF21243D);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchTextController,
              autofocus: true,
              onSubmitted: _didSubmitSearch,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0)),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                hintText: "Search products, articles, faq, ...",
                suffixIcon: searchTextController.text.isNotEmpty
                    ? IconButton(
                        onPressed: searchTextController.clear,
                        icon: Icon(Icons.clear, color: primaryColor),
                      )
                    : null,
              ),
            ),
          ),
          TextButton(
              onPressed: () => {Navigator.pop(context)}, child: Text("Cancel"))
        ],
      ),
    );
  }

  Widget _historyRow(String suggestion) {
    return Row(children: [
      Icon(Icons.replay),
      SizedBox(
        width: 10,
      ),
      Text(suggestion, style: TextStyle(fontSize: 16)),
      Spacer(),
      IconButton(
          onPressed: () => _removeFromHistory(suggestion),
          icon: Icon(Icons.close, color: Colors.grey)),
      IconButton(
        onPressed: () => _completeSuggestion(suggestion),
        icon: Icon(Icons.north_west, color: Colors.grey),
      )
    ]);
  }

  Widget _suggestionRow(String suggestion) {
    return Row(children: [
      Icon(Icons.search),
      SizedBox(
        width: 10,
      ),
      Text(suggestion, style: TextStyle(fontSize: 16)),
      Spacer(),
      IconButton(
        onPressed: () => _completeSuggestion(suggestion),
        icon: Icon(Icons.north_west, color: Colors.grey),
      )
    ]);
  }

  Widget _customScrollView() {
    var sectionHeaderTextStyle = TextStyle(
        fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400);
    return Expanded(
        child: CustomScrollView(
      slivers: [
        if (_history.isNotEmpty) ...[
          SliverAppBar(
              titleTextStyle: sectionHeaderTextStyle,
              title: Row(
                children: [Text("Your searches"), Spacer()],
              ),
              automaticallyImplyLeading: false),
          SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    String suggestion = _history[index];
                    return SizedBox(
                        height: 50,
                        child: InkWell(
                            onTap: () => _launchSearch(suggestion),
                            child: _historyRow(suggestion)));
                  },
                  childCount: _history.length,
                ),
              )),
        ],
        SliverAppBar(
            titleTextStyle: sectionHeaderTextStyle,
            title: Row(children: [Text("Popular searches"), Spacer()]),
            automaticallyImplyLeading: false),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              String suggestion = _suggestions[index].query;
              return SizedBox(
                  height: 50,
                  child: InkWell(
                      onTap: () => _launchSearch(suggestion),
                      child: _suggestionRow(suggestion)));
            },
            childCount: _suggestions.length,
          )),
        ),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(_didChangeSearchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      _header(),
      SizedBox(height: 20),
      _customScrollView(),
    ])));
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }
}
