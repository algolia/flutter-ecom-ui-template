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
  final List<QuerySuggestion> _suggestions = [];

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() async {
    final query = Query(searchTextController.text);
    final received = await suggestionsRepository.getSuggestions(query);
    _suggestions.clear();
    setState(() => _suggestions.addAll(received));
  }

  void _addToHistory(String query) {
    if (query.isEmpty) return;
    _history.removeWhere((element) => element == query);
    setState(() => _history.add(query));
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

  void _launchSearch(String query) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              SearchResultsScreen(query: Query(query)),
        ));
  }

  void _submitSearch(String query) {
    _addToHistory(query);
    _launchSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      _header(),
      const SizedBox(height: 20),
      _body(),
    ])));
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SearchHeaderView(
        controller: searchTextController,
        onSubmitted: _submitSearch,
      ),
    );
  }

  Widget _body() {
    return Expanded(
        child: CustomScrollView(
      slivers: [
        if (_history.isNotEmpty)
          ..._section("Your searches", _history, (String item) {
            return HistoryRowView(
                suggestion: item,
                onTap: _completeSuggestion,
                onRemove: _removeFromHistory);
          }),
        if (_suggestions.isNotEmpty)
          ..._section("Popular searches", _suggestions, (QuerySuggestion item) {
            return SuggestionRowView(
                suggestion: item,
                onTap: _completeSuggestion);
          })
      ],
    ));
  }

  List<Widget> _section<Suggestion>(
      String title, List<Suggestion> items, Function(Suggestion) rowBuilder) {
    final sectionHeaderTextStyle =
        Theme.of(context).textTheme.subtitle2?.copyWith(color: Colors.grey);
    return [
      SliverAppBar(
          titleTextStyle: sectionHeaderTextStyle,
          title: Row(
            children: [Text(title), Spacer()],
          ),
          automaticallyImplyLeading: false),
      SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final item = items[index];
              return SizedBox(
                  height: 50,
                  child: InkWell(
                      onTap: () => _submitSearch(item.toString()),
                      child: rowBuilder(item)));
            },
            childCount: items.length,
          )))
    ];
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }
}
