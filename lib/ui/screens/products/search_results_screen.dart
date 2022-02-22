import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/model/query.dart';
import 'package:flutter_ecom_demo/ui/screens/product/product_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/paged_hits_grid_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/paged_hits_list_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/app_bar_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  final Query query;

  @override
  _SearchResultsScreen createState() => _SearchResultsScreen();
}

class _SearchResultsScreen extends State<SearchResultsScreen> {
  final _productRepository = ProductRepository();

  Query get _query => widget.query;
  int _resultsCount = 0;
  _HitsDisplay _display = _HitsDisplay.grid;

  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    _query.page = pageKey;
    try {
      final response = await _productRepository.searchProducts(_query);
      final hits = response.hits ?? List.empty();
      final isLastPage = response.page == response.nbPages;
      final nextPageKey = isLastPage ? null : pageKey + 1;
      _pagingController.appendPage(hits, nextPageKey);
      setState(() {
        _resultsCount = response.nbHits?.toInt() ?? 0;
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarView(),
      body: SafeArea(
          child: Column(
        children: [
          _searchHeader(context),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _displaySwitcher()),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                child: _hitsDisplay()),
          ),
        ],
      )),
    );
  }

  Row _searchHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
        Text('Search results for: ',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.grey)),
        Text('"${_query.query}" ',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text('($_resultsCount)',
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }

  Widget _displaySwitcher() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Display'),
        const SizedBox(width: 10),
        SizedBox(
          height: 20,
          width: 20,
          child: IconButton(
            splashRadius: 10,
            padding: const EdgeInsets.all(0.0),
            onPressed: () => setState(() {
              _display = _HitsDisplay.grid;
            }),
            icon: Icon(Icons.grid_view,
                size: 20,
                color: _HitsDisplay.grid == _display ? Colors.blue : null),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 20,
          width: 20,
          child: IconButton(
            splashRadius: 10,
            padding: const EdgeInsets.all(0.0),
            onPressed: () => setState(() {
              _display = _HitsDisplay.list;
            }),
            icon: Icon(Icons.view_list,
                size: 20,
                color: _HitsDisplay.list == _display ? Colors.blue : null),
          ),
        ),
      ],
    );
  }

  Widget _hitsDisplay() {
    switch (_display) {
      case _HitsDisplay.list:
        return PagedHitsListView(
            pagingController: _pagingController,
            onHitClick: (objectID) => _presentProductPage(context, objectID),
            noItemsFound: _noResults);
      case _HitsDisplay.grid:
        return PagedHitsGridView(
            pagingController: _pagingController,
            onHitClick: (objectID) => _presentProductPage(context, objectID),
            noItemsFound: _noResults);
    }
  }

  void _presentProductPage(BuildContext context, String productID) {
    _productRepository.getProduct(productID).then((product) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ProductScreen(product: product),
        )));
  }

  Widget _noResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Try the following:",
              style: Theme.of(context).textTheme.bodyText1),
          const SizedBox(height: 4),
          Text("• Searching again using more general terms",
              style: Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

enum _HitsDisplay { list, grid }
