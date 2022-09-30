import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/search_repository.dart';
import '../../../data/suggestion_repository.dart';
import '../../../model/query_suggestion.dart';
import '../../app_theme.dart';
import '../products/search_results_screen.dart';
import 'components/history_row_view.dart';
import 'components/search_header_view.dart';
import 'components/suggestion_row_view.dart';

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          controller: _searchTextController,
          onSubmitted: (query) => _onSubmitSearch(query, context),
          onChanged: suggestionRepository.query,
        ),
      ),
      const SliverToBoxAdapter(
          child: SizedBox(
        height: 10,
      )),
      _sectionHeader(
        suggestionRepository.history,
        Row(
          children: [
            const Text(
              "Your searches",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
                onPressed: () => suggestionRepository.clearHistory(),
                child: const Text("Clear",
                    style: TextStyle(color: AppTheme.nebula)))
          ],
        ),
      ),
      _sectionBody(
          context,
          suggestionRepository.history,
          (String item) => HistoryRowView(
              suggestion: item,
              onRemove: (item) =>
                  suggestionRepository.removeFromHistory(item))),
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
              onComplete: (suggestion) =>
                  _searchTextController.value = TextEditingValue(
                    text: suggestion,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: suggestion.length),
                    ),
                  ))),
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

  Widget _sectionBody<Item>(
    BuildContext context,
    Stream<List<Item>> itemsStream,
    Function(Item) rowBuilder,
  ) =>
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
    context.read<SuggestionRepository>().addToHistory(query);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Provider<SearchRepository>(
              create: (_) => SearchRepository(),
              dispose: (_, value) => value.dispose(),
              child: SearchResultsScreen(query: query)),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextController.dispose();
  }
}
