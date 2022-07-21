import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/query.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';
import 'package:flutter_ecom_demo/ui/screens/products/search_results_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/history_row_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/search_header_view.dart';

import '../../../data/suggestion_searcher.dart';
import '../../app_theme.dart';
import 'components/suggestion_row_view.dart';

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {
  final searchTextController = TextEditingController();
  final suggestionSearcher = SuggestionSearcher();

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() async {
    suggestionSearcher.query(searchTextController.text);
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
    setState(() => suggestionSearcher.addToHistory(query));
    _launchSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.neutralLightest,
            titleSpacing: 0,
            elevation: 0,
            title: SearchHeaderView(
              controller: searchTextController,
              onSubmitted: _submitSearch,
            )),
        body: Column(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _buildSuggestions(),
          )),
        ]));
  }

  Widget _buildSuggestions() {
    return StreamBuilder<List<QuerySuggestion>>(
        stream: suggestionSearcher.suggestions,
        builder: (context, snapshot) {
          final suggestions = snapshot.data ?? [];
          return CustomScrollView(
            slivers: [
              if (suggestionSearcher.history.isNotEmpty)
                ..._section(
                    Row(
                      children: [
                        const Text("Your searches"),
                        const Spacer(),
                        TextButton(
                            onPressed: () => setState(
                                () => suggestionSearcher.clearHistory()),
                            child: const Text("Clear",
                                style: TextStyle(color: AppTheme.nebula)))
                      ],
                    ),
                    suggestionSearcher.history, (String item) {
                  return HistoryRowView(
                      suggestion: item,
                      onRemove: (item) => setState(
                          () => suggestionSearcher.removeFromHistory(item)));
                }),
              if (suggestions.isNotEmpty)
                ..._section(
                    Row(
                      children: const [Text("Popular searches"), Spacer()],
                    ),
                    suggestions, (QuerySuggestion item) {
                  return SuggestionRowView(
                      suggestion: item, onComplete: _completeSuggestion);
                })
            ],
          );
        });
  }

  List<Widget> _section<Suggestion>(
      Widget title, List<Suggestion> items, Function(Suggestion) rowBuilder) {
    return [
      SliverAppBar(
          titleSpacing: 0,
          titleTextStyle: Theme.of(context).textTheme.subtitle2,
          title: title,
          automaticallyImplyLeading: false),
      SliverList(
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
      ))
    ];
  }

  @override
  void dispose() {
    searchTextController.dispose();
    suggestionSearcher.dispose();
    super.dispose();
  }
}
