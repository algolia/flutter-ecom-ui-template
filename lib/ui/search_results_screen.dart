import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/domain/product.dart';
import 'package:flutter_ecom_demo/domain/query.dart';
import 'package:flutter_ecom_demo/ui/product_screen.dart';
import 'package:flutter_ecom_demo/ui/widgets/icon_label.dart';
import 'package:flutter_ecom_demo/ui/widgets/product_card_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/product_item_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  final String query;

  @override
  _SearchResultsScreen createState() => _SearchResultsScreen();
}

class _SearchResultsScreen extends State<SearchResultsScreen> {
  final _productRepository = ProductRepository();

  Query get _query => Query(widget.query);
  int _resultsCount = 0;

  bool _isGrid = true;

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
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/og.png', height: 128),
        actions: const [
          IconLabel(icon: Icons.pin_drop_outlined, text: 'STORES'),
          IconLabel(icon: Icons.person_outline, text: 'ACCOUNTS'),
          IconLabel(icon: Icons.shopping_bag_outlined, text: 'CART')
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Row(
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
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
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
                      _isGrid = true;
                    }),
                    icon: Icon(Icons.grid_view,
                        size: 20, color: _isGrid ? Colors.blue : null),
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
                      _isGrid = false;
                    }),
                    icon: Icon(Icons.view_list,
                        size: 20, color: !_isGrid ? Colors.blue : null),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _isGrid ? productsGrid() : productsList()),
          ),
        ],
      )),
    );
  }

  void presentProductPage(BuildContext context, String productID) {
    _productRepository
        .getProduct(productID)
        .then((product) => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return ProductScreen(product: product);
              },
            )));
  }

  Widget productsGrid() {
    return PagedGridView<int, Product>(
      shrinkWrap: true,
      pagingController: _pagingController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.9,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
      ),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) => ProductCardView(
            product: item,
            imageAlignment: Alignment.bottomCenter,
            onProductPressed: (objectID) {
              presentProductPage(context, objectID);
            }),
      ),
    );
  }

  Widget productsList() {
    return PagedListView<int, Product>.separated(
      shrinkWrap: true,
      pagingController: _pagingController,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) => ProductItemView(
            product: item,
            imageAlignment: Alignment.bottomCenter,
            onProductPressed: (objectID) {
              presentProductPage(context, objectID);
            }),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
