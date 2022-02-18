import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/suggestion_repository.dart';
import 'package:flutter_ecom_demo/model/query.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';
import 'package:flutter_ecom_demo/ui/screens/products/search_results_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/history_row_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/search_header_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/suggestion_row_view.dart';

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {
  final suggestionsRepository = SuggestionRepository();
  final searchTextController = TextEditingController();

  final List<String> _history = ['jackets'];
  List<QuerySuggestion> _suggestions = [];

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(_didChangeSearchText);
  }

  void _didChangeSearchText() async {
    final query = Query(searchTextController.text);
    final received = await suggestionsRepository.getSuggestions(query);
    setState(() => _suggestions = received);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      _header(),
      const SizedBox(height: 20),
      _customScrollView(),
    ])));
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SearchHeaderView(
        controller: searchTextController,
        onSubmitted: _didSubmitSearch,
      ),
    );
  }

  void _didSubmitSearch(String query) {
    _addToHistory(query);
    _launchSearch(query);
  }

  void _addToHistory(String query) {
    if (query.isEmpty) return;
    _history.removeWhere((element) => element == query);
    setState(() => _history.add(query));
  }

  void _launchSearch(String query) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              SearchResultsScreen(query: Query(query)),
        ));
  }

  Widget _customScrollView() {
    final sectionHeaderTextStyle =
        Theme.of(context).textTheme.subtitle2?.copyWith(color: Colors.grey);
    return Expanded(
        child: CustomScrollView(
      slivers: [
        if (_history.isNotEmpty) ...[
          SliverAppBar(
              titleTextStyle: sectionHeaderTextStyle,
              title: Row(
                children: const [Text("Your searches"), Spacer()],
              ),
              automaticallyImplyLeading: false),
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    String suggestion = _history[index];
                    return SizedBox(
                        height: 50,
                        child: InkWell(
                            onTap: () => _launchSearch(suggestion),
                            child: HistoryRowView(
                                suggestion: suggestion,
                                onTap: _completeSuggestion,
                                onRemove: _removeFromHistory)));
                  },
                  childCount: _history.length,
                ),
              )),
        ],
        SliverAppBar(
            titleTextStyle: sectionHeaderTextStyle,
            title: Row(children: const [Text("Popular searches"), Spacer()]),
            automaticallyImplyLeading: false),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              QuerySuggestion suggestion = _suggestions[index];
              return SizedBox(
                  height: 50,
                  child: InkWell(
                      onTap: () => _didSubmitSearch(suggestion.query),
                      child: SuggestionRowView(
                          suggestion: suggestion,
                          onPressed: _completeSuggestion)));
            },
            childCount: _suggestions.length,
          )),
        ),
      ],
    ));
  }

  void _removeFromHistory(String query) {
    setState(() => _history.removeWhere((element) => element == query));
  }

  void _completeSuggestion(String suggestion) {
    searchTextController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.fromPosition(
        TextPosition(offset: suggestion.length),
      ),
    );
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }
}
