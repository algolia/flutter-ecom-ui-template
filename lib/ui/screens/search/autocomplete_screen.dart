import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/data/suggestion_repository.dart';
import 'package:flutter_ecom_demo/model/query_suggestion.dart';
import 'package:flutter_ecom_demo/ui/screens/products/search_results_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/history_row_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/search_header_view.dart';
import 'package:flutter_ecom_demo/ui/screens/search/components/suggestion_row_view.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _launchSearch(String query, ProductRepository productRepository) {
    productRepository.pagingController.refresh();
    productRepository.search((state) => state.copyWith(query: query));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SearchResultsScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<SuggestionRepository>(
            builder: (_, suggestionsRepository, __) =>
                CustomScrollView(slivers: [
                  SliverAppBar(
                    leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back)),
                    backgroundColor: AppTheme.neutralLightest,
                    pinned: true,
                    titleSpacing: 0,
                    elevation: 0,
                    title: Consumer<ProductRepository>(
                      builder: (_, productRepository, __) => SearchHeaderView(
                        controller: suggestionsRepository.searchTextController,
                        onSubmitted: (query) {
                          suggestionsRepository.addToHistory(query);
                          _launchSearch(query, productRepository);
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 10,
                  )),
                  ..._section(
                      Row(
                        children: [
                          const Text(
                            "Your searches",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          TextButton(
                              onPressed: () => setState(
                                  () => suggestionsRepository.clearHistory()),
                              child: const Text("Clear",
                                  style: TextStyle(color: AppTheme.nebula)))
                        ],
                      ),
                      suggestionsRepository.history,
                      (String item) => HistoryRowView(
                          suggestion: item,
                          onRemove: (item) => setState(() =>
                              suggestionsRepository.removeFromHistory(item))),
                      suggestionsRepository),
                  ..._section(
                      const Text(
                        "Popular searches",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      suggestionsRepository.suggestions,
                      (QuerySuggestion item) => SuggestionRowView(
                          suggestion: item,
                          onComplete: suggestionsRepository.completeSuggestion),
                      suggestionsRepository)
                ])));
  }

  List<Widget> _section<Suggestion>(
      Widget title,
      Stream<List<Suggestion>> items,
      Function(Suggestion) rowBuilder,
      SuggestionRepository suggestionsRepository) {
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
                            return Consumer<ProductRepository>(
                                builder: (_, productRepository, __) => InkWell(
                                    onTap: () {
                                      final query = item.toString();
                                      suggestionsRepository.addToHistory(query);
                                      _launchSearch(query, productRepository);
                                    },
                                    child: rowBuilder(item)));
                          },
                          childCount: suggestions.length,
                        ))));
          })
    ];
  }
}
