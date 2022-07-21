import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_searcher.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/model/query.dart';
import 'package:flutter_ecom_demo/ui/screens/product/product_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/mode_switcher_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/no_results_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/paged_hits_grid_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/paged_hits_list_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/search_header_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/app_bar_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  final Query query;

  @override
  _SearchResultsScreen createState() => _SearchResultsScreen();
}

class _SearchResultsScreen extends State<SearchResultsScreen> {
  final ProductsSearcher _productsSearcher = ProductsSearcher();

  Query get _query => widget.query;
  int _resultsCount = 0;
  HitsDisplay _display = HitsDisplay.grid;

  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _setupSearch();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    super.initState();
  }

  void _setupSearch() {
    _productsSearcher.paginate(
        onNextPage: (page) {
          _pagingController.appendPage(page.data, page.nextPageKey);
          setState(() => _resultsCount = page.nbHits);
        },
        onError: (error) => _pagingController.error = error);
  }

  void _fetchPage(int pageKey) {
    _productsSearcher.page(pageKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarView(),
      body: SafeArea(
          child: Column(
        children: [
          SearchHeaderView(
              query: _query.query ?? "", resultsCount: _resultsCount),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ModeSwitcherView(
                  currentDisplay: _display,
                  onPressed: (display) => setState(() => _display = display))),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                child: _hitsDisplay()),
          ),
        ],
      )),
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
    _productsSearcher.getById(productID).then((product) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductScreen(product: product))));
  }

  Widget _noResults(BuildContext context) {
    return const NoResultsView();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
