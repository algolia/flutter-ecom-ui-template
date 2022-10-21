import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../data/product_repository.dart';
import '../../../data/search_repository.dart';
import '../../../model/product.dart';
import '../../../model/search_metadata.dart';
import '../../widgets/app_bar_view.dart';
import '../filters/filters_screen.dart';
import '../product/product_screen.dart';
import 'components/mode_switcher_view.dart';
import 'components/no_results_view.dart';
import 'components/paged_hits_grid_view.dart';
import 'components/paged_hits_list_view.dart';
import 'components/search_header_view.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  final String query;

  @override
  _SearchResultsScreen createState() => _SearchResultsScreen();
}

class _SearchResultsScreen extends State<SearchResultsScreen> {
  HitsDisplay _display = HitsDisplay.grid;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);

  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    final searchRepository = context.read<SearchRepository>();
    _pagingController.addPageRequestListener(searchRepository.setPage);
    _subscription = searchRepository.productsPage.listen((products) {
      if (products.page == 0) _pagingController.refresh();
      _pagingController.appendPage(products.items, products.nextPage);
    })
      ..onError((error) => _pagingController.error = error);

    searchRepository.search(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    final searchRepository = context.read<SearchRepository>();
    return Scaffold(
      key: _key,
      appBar: const AppBarView(),
      endDrawer: const Drawer(
        child: FiltersScreen(),
      ),
      body: Column(
        children: [
          StreamBuilder<SearchMetadata>(
            stream: searchRepository.searchMetadata,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return StreamBuilder<int>(
                    stream: searchRepository.appliedFiltersCount,
                    builder: (context, snapshot) => SearchHeaderView(
                          query: data.query,
                          resultsCount: data.nbHits,
                          filtersButtonTapped: () {
                            _key.currentState?.openEndDrawer();
                          },
                          appliedFiltersCount: snapshot.data ?? 0,
                        ));
              } else {
                return Container();
              }
            },
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ModeSwitcherView(
                  currentDisplay: _display,
                  onPressed: (display) => setState(() => _display = display))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
              child: _hitsDisplay(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hitsDisplay() {
    switch (_display) {
      case HitsDisplay.list:
        return PagedHitsListView(
            pagingController: _pagingController,
            onHitClick: (objectID) => _presentProductPage(context, objectID),
            noItemsFound: _noResults);
      case HitsDisplay.grid:
        return PagedHitsGridView(
            pagingController: _pagingController,
            onHitClick: (objectID) => _presentProductPage(context, objectID),
            noItemsFound: _noResults);
    }
  }

  void _presentProductPage(BuildContext context, String productID) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Provider<ProductRepository>(
              create: (_) => ProductRepository(),
              dispose: (_, value) => value.dispose(),
              child: ProductScreen(productID: productID)),
        ));
  }

  Widget _noResults(BuildContext context) {
    return const NoResultsView();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _pagingController.dispose();
  }
}
