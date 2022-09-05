import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/suggestion_repository.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';
import 'package:flutter_ecom_demo/ui/screens/products/search_results_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/history_row_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/search_header_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/suggestion_row_view.dart';
import '../../app_theme.dart';

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {
  final suggestionsRepository = SuggestionRepository();
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() async {
    suggestionsRepository.searchSuggestions(searchTextController.text);
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
          builder: (BuildContext context) => SearchResultsScreen(query: query),
        ));
  }

  void _submitSearch(String query) {
    suggestionsRepository.addToHistory(query);
    _launchSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: AppTheme.neutralLightest,
        pinned: true,
        titleSpacing: 0,
        elevation: 0,
        title: SearchHeaderView(
          controller: searchTextController,
          onSubmitted: _submitSearch,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10,)),
      ..._section(
          Row(
            children: [
              const Text(
                "Your searches",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () =>
                      setState(() => suggestionsRepository.clearHistory()),
                  child: const Text("Clear",
                      style: TextStyle(color: AppTheme.nebula)))
            ],
          ),
          suggestionsRepository.history,
          (String item) => HistoryRowView(
              suggestion: item,
              onRemove: (item) => setState(
                  () => suggestionsRepository.removeFromHistory(item)))),
      ..._section(
          const Text(
            "Popular searches",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          suggestionsRepository.suggestions,
          (QuerySuggestion item) => SuggestionRowView(
              suggestion: item, onComplete: _completeSuggestion))
    ]));
  }

  List<Widget> _section<Suggestion>(Widget title,
      Stream<List<Suggestion>> items, Function(Suggestion) rowBuilder) {
    return [
      StreamBuilder<List<Suggestion>>(
          stream: items,
          builder: (context, snapshot) {
            final suggestions = snapshot.data ?? [];
            return SliverSafeArea(
                top: false,
                bottom: false,
                sliver: SliverPadding(
                    padding: const EdgeInsets.only(left: 15),
                    sliver: SliverToBoxAdapter(
                      child:
                          suggestions.isEmpty ? const SizedBox.shrink() : title,
                    )));
          }),
      StreamBuilder<List<Suggestion>>(
          stream: items,
          builder: (context, snapshot) {
            final suggestions = snapshot.data ?? [];
            if (suggestions.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            return SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                    padding: const EdgeInsets.only(left: 15),
                    sliver: SliverFixedExtentList(
                        itemExtent: 44,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = suggestions[index];
                            return InkWell(
                                onTap: () => _submitSearch(item.toString()),
                                child: rowBuilder(item));
                          },
                          childCount: suggestions.length,
                        ))));
          })
    ];
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }
}
