import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/algolia_client.dart';
import 'package:flutter_ecom_demo/domain/query.dart';

class QuerySuggestion {
  String query;

  QuerySuggestion(this.query);

  static QuerySuggestion fromJson(Map<String, dynamic> json) {
    return QuerySuggestion(json["query"]);
  }

}

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {

  var algoliaClient = AlgoliaAPIClient("latency", "927c3fe76d4b52c5a2912973f35a3077", "STAGING_native_ecom_demo_products_query_suggestions");
  var searchTextController = TextEditingController();

  List<String> _history = ['jackets'];
  List<QuerySuggestion> _suggestions = [];

  void _didChangeSearchText() {
    final queryString = searchTextController.text;
    print(queryString);
    final query = Query(queryString);
    algoliaClient.search(query).then((value) => _handleResponse(value));
  }

  void _handleResponse(Map<dynamic, dynamic> response) {
    final hits = response["hits"];
    final receivedSuggestions = List<QuerySuggestion>.from(hits.map((hit) => QuerySuggestion.fromJson(hit)));
    setState(() {
      _suggestions = receivedSuggestions;
    });
  }

  void _didSumbitSearch(String query) {
    _addToHistory(query);
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

  void _applySuggestion(String suggestion) {
    searchTextController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.fromPosition(
        TextPosition(offset: suggestion.length),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchTextController,
              autofocus: true,
              onSubmitted: _didSumbitSearch,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black87, width: 1.0),
                ),
                prefixIcon: Icon(Icons.search),
                hintText: "Search products, articles, faq, ...",
                suffixIcon: IconButton(
                  onPressed: searchTextController.clear,
                  icon: Icon(Icons.clear),
                ),
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
      Text(suggestion, style: TextStyle(fontSize: 20)),
      Spacer(),
      IconButton(onPressed: () => _removeFromHistory(suggestion), icon: Icon(Icons.close)),
      SizedBox(width: 10),
      Icon(Icons.north_west),
    ]);
  }

  Widget _suggestionRow(String suggestion) {
    return Row(children: [
      Icon(Icons.search),
      SizedBox(
        width: 10,
      ),
      Text(suggestion, style: TextStyle(fontSize: 20)),
      Spacer(),
      Icon(Icons.north_west),
    ]);
  }

  Widget _customScrollView() {
    return Expanded(
        child: CustomScrollView(
      slivers: [
        if (_history.isNotEmpty) ...[
          SliverAppBar(
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
                            onTap: () => _applySuggestion(suggestion),
                            child: _historyRow(suggestion)));
                  },
                  childCount: _history.length,
                ),
              )),
        ],
        SliverAppBar(
            title: Row(children: [
              Text(
                "Popular searches",
              ),
              Spacer()
            ]),
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
                      onTap: () => _applySuggestion(suggestion),
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
      _searchBar(),
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
