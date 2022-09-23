import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/history_repository.dart';
import 'package:flutter_ecom_demo/data/search_repository.dart';
import 'package:flutter_ecom_demo/data/suggestion_repository.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';
import 'package:flutter_ecom_demo/ui/screens/products/search_results_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/history_row_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/search_header_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/suggestion_row_view.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class AutocompleteScreen extends StatelessWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchHistoryRepository = context.read<SearchHistoryRepository>();
    final suggestionRepository = context.read<SuggestionRepository>();
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
          controller: suggestionRepository.searchTextController,
          onSubmitted: (query) => _onSubmitSearch(query, context),
        ),
      ),
      const SliverToBoxAdapter(
          child: SizedBox(
        height: 10,
      )),
      _sectionHeader(
        searchHistoryRepository.history,
        Row(
          children: [
            const Text(
              "Your searches",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
                onPressed: () => searchHistoryRepository.clearHistory(),
                child: const Text("Clear",
                    style: TextStyle(color: AppTheme.nebula)))
          ],
        ),
      ),
      _sectionBody(
          context,
          searchHistoryRepository.history,
          (String item) => HistoryRowView(
              suggestion: item,
              onRemove: (item) =>
                  searchHistoryRepository.removeFromHistory(item))),
      _sectionHeader(
          suggestionRepository.suggestions,
          const Text(
            "Popular searches",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      _sectionBody(
          context,
          suggestionRepository.suggestions,
          (QuerySuggestion item) => SuggestionRowView(
              suggestion: item,
              onComplete: suggestionRepository.completeSuggestion)),
    ]));
  }

  Widget _sectionHeader<Item>(Stream<List<Item>> itemsStream, Widget title) =>
      StreamBuilder<List<Item>>(
          stream: itemsStream,
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
          });

  Widget _sectionBody<Item>(BuildContext context,
          Stream<List<Item>> itemsStream, Function(Item) rowBuilder) =>
      StreamBuilder<List<Item>>(
          stream: itemsStream,
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
                                onTap: () {
                                  final query = item.toString();
                                  _onSubmitSearch(query, context);
                                },
                                child: rowBuilder(item));
                          },
                          childCount: suggestions.length,
                        ))));
          });

  void _onSubmitSearch(String query, BuildContext context) {
    context.read<SearchHistoryRepository>().addToHistory(query);
    context.read<SearchRepository>().search(query);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SearchResultsScreen(),
        ));
  }
}
