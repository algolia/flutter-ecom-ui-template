import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/data/search_history_repository.dart';
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

  void _onSubmitSearch(String query) {
    context.read<SearchHistoryRepository>().addToHistory(query);
    final productRepository = context.read<ProductRepository>();
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
          controller: context.read<SuggestionRepository>().searchTextController,
          onSubmitted: _onSubmitSearch,
        ),
      ),
      const SliverToBoxAdapter(
          child: SizedBox(
        height: 10,
      )),
      _sectionHeader(
        context.read<SearchHistoryRepository>().history,
        Row(
          children: [
            const Text(
              "Your searches",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
                onPressed: () =>
                    context.read<SearchHistoryRepository>().clearHistory(),
                child: const Text("Clear",
                    style: TextStyle(color: AppTheme.nebula)))
          ],
        ),
      ),
      _sectionBody(
          context.read<SearchHistoryRepository>().history,
          (String item) => HistoryRowView(
              suggestion: item,
              onRemove: (item) => context
                  .read<SearchHistoryRepository>()
                  .removeFromHistory(item))),
      _sectionHeader(
          context.read<SearchHistoryRepository>().history,
          const Text(
            "Popular searches",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      _sectionBody(
          context.read<SuggestionRepository>().suggestions,
          (QuerySuggestion item) => SuggestionRowView(
              suggestion: item,
              onComplete:
                  context.read<SuggestionRepository>().completeSuggestion)),
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
                                  _onSubmitSearch(query);
                                },
                                child: rowBuilder(item));
                          },
                          childCount: suggestions.length,
                        ))));
          });
}
