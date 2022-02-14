import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/home_screen.dart';

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {

  var searchTextController = TextEditingController();

  List<String> _history = ['jackets'];
  List<String> _suggestions = [
    'jackets',
    'shoes',
    'shoes black',
    'sweater',
    'moncler',
    'shoes',
    't-shirt'
  ];

  void _didChangeSearchText() {
    print(searchTextController.text);
  }

  void _didSumbitSearch(String query) {
    _addToHistory(query);
  }

  void _addToHistory(String query) {
    if (query.isEmpty) {
      return;
    }
    _removeFromHistory(query);
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
                  childCount: _history.length, // 1000 list items
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
              String suggestion = _suggestions[index];
              return SizedBox(
                  height: 50,
                  child: InkWell(
                      onTap: () => _applySuggestion(suggestion),
                      child: _suggestionRow(suggestion)));
            },
            childCount: _suggestions.length, // 1000 list items
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
