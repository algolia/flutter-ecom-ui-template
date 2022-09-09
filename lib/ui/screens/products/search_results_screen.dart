import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/ui/screens/product/product_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/mode_switcher_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/no_results_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/paged_hits_grid_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/paged_hits_list_view.dart';
import 'package:flutter_ecom_demo/ui/screens/products/components/search_header_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/app_bar_view.dart';
import 'package:provider/provider.dart';

import '../filters/filters_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  _SearchResultsScreen createState() => _SearchResultsScreen();
}

class _SearchResultsScreen extends State<SearchResultsScreen> {
  HitsDisplay _display = HitsDisplay.grid;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: const AppBarView(),
      endDrawer: const Drawer(
        child: FiltersScreen(),
      ),
      body: Column(
        children: [
          Consumer<ProductRepository>(
              builder: (_, productRepository, __) =>
                  StreamBuilder<SearchResponse>(
                    stream: productRepository.searchResult,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return StreamBuilder<int>(
                            stream: productRepository.appliedFiltersCount,
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
                  )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ModeSwitcherView(
                  currentDisplay: _display,
                  onPressed: (display) => setState(() => _display = display))),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                child: Consumer<ProductRepository>(
                  builder: (_, productRepository, __) =>
                      _hitsDisplay(productRepository),
                )),
          ),
        ],
      ),
    );
  }

  Widget _hitsDisplay(ProductRepository productRepository) {
    switch (_display) {
      case HitsDisplay.list:
        return PagedHitsListView(
            pagingController: productRepository.pagingController,
            onHitClick: (objectID) =>
                _presentProductPage(context, objectID, productRepository),
            noItemsFound: _noResults);
      case HitsDisplay.grid:
        return PagedHitsGridView(
            pagingController: productRepository.pagingController,
            onHitClick: (objectID) =>
                _presentProductPage(context, objectID, productRepository),
            noItemsFound: _noResults);
    }
  }

  void _presentProductPage(BuildContext context, String productID,
      ProductRepository productRepository) {
    productRepository.getProduct(productID).then((product) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ProductScreen(product: product),
        )));
  }

  Widget _noResults(BuildContext context) {
    return const NoResultsView();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
