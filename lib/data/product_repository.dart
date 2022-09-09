import 'package:algolia/algolia.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import '../model/page.dart' as ecom_page;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Products data repository.
class ProductRepository extends ChangeNotifier {
  ProductRepository._internal() {
    _hitsSearcher.applyState((state) =>
        state.copyWith(disjunctiveFacets: {'brand', 'available_sizes'}));
    _hitsSearcher.connectFilterState(_filterState);
    _brandFacetList = FacetList(
        searcher: _hitsSearcher, filterState: _filterState, attribute: 'brand');
    _sizeFacetList = FacetList(
        searcher: _hitsSearcher,
        filterState: _filterState,
        attribute: 'available_sizes');
    pagingController.addPageRequestListener((pageKey) {
      search((state) => state.copyWith(page: pageKey));
    });
    searchPage.listen((page) {
      pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) {
      pagingController.error = error;
    });
  }

  static final ProductRepository _instance = ProductRepository._internal();

  factory ProductRepository() {
    return _instance;
  }

  final _hitsSearcher = HitsSearcher(
      applicationID: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey,
      indexName: Credentials.hitsIndex);

  final _filterState = FilterState();

  late FacetList _brandFacetList;
  late FacetList _sizeFacetList;

  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  final _shoesSearcher = HitsSearcher.create(
      applicationID: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey,
      state:
          const SearchState(indexName: Credentials.hitsIndex, query: 'shoes'));

  final _seasonalProductsSearcher = HitsSearcher.create(
      applicationID: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey,
      state: const SearchState(
          indexName: Credentials.hitsIndex,
          ruleContexts: ['home-spring-summer-2021']));

  final _recommendedProductsSearcher = HitsSearcher.create(
      applicationID: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey,
      state:
          const SearchState(indexName: Credentials.hitsIndex, query: 'jacket'));

  final Algolia _algoliaClient = const Algolia.init(
      applicationId: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey);

  /// Get products list by query.
  void search(SearchState Function(SearchState state) query) {
    _hitsSearcher.applyState(query);
  }

  /// Toggle selection of a brand facet
  void toggleBrand(String brand) {
    pagingController.refresh();
    _brandFacetList.toggle(brand);
  }

  /// Toggle selection of a size facet
  void toggleSize(String size) {
    pagingController.refresh();
    _sizeFacetList.toggle(size);
  }

  /// Get the name of currently selected index
  String get selectedIndexName => _hitsSearcher.snapshot().indexName;

  /// Update the name of the index to target
  void selectIndexName(String indexName) {
    if (_hitsSearcher.snapshot().indexName == indexName) {
      return;
    }
    pagingController.refresh();
    _hitsSearcher.applyState((state) => state.copyWith(indexName: indexName));
  }

  /// Get count of applied filters
  Stream<int> get appliedFiltersCount =>
      _filterState.filters.map((event) => event.getFilters().length);

  /// Get stream of list of brand facets
  Stream<List<SelectableFacet>> get brandFacets => _brandFacetList.facets;

  /// Get stream of list of size facets
  Stream<List<SelectableFacet>> get sizeFacets => _sizeFacetList.facets;

  /// Clear all filters
  void clearFilters() {
    if (_filterState.snapshot().getFilters().isEmpty) {
      return;
    }
    pagingController.refresh();
    _filterState.clear();
  }

  /// Get stream of shoes products.
  Stream<List<Product>> get shoes => _shoesSearcher.responses.map(
      (response) => response.hits.map((hit) => Product.fromJson(hit)).toList());

  /// Get stream of seasonal products.
  Stream<List<Product>> get seasonalProducts =>
      _seasonalProductsSearcher.responses.map((response) =>
          response.hits.map((hit) => Product.fromJson(hit)).toList());

  /// Get stream of recommended products.
  Stream<List<Product>> get recommendedProducts =>
      _recommendedProductsSearcher.responses.map((response) =>
          response.hits.map((hit) => Product.fromJson(hit)).toList());

  /// Get stream of latest search page
  Stream<ecom_page.Page<Product>> get searchPage =>
      _hitsSearcher.responses.map((response) {
        final isLastPage = response.page == response.nbPages;
        final nextPageKey = isLastPage ? null : response.page + 1;
        return ecom_page.Page(
            response.hits.map((h) => Product.fromJson(h)).toList(),
            nextPageKey);
      });

  /// Get stream of latest search result
  Stream<SearchResponse> get searchResult => _hitsSearcher.responses;

  /// Get product by ID.
  Future<Product> getProduct(String productID) async {
    List<AlgoliaObjectSnapshot> products = await _algoliaClient.instance
        .index(Credentials.hitsIndex)
        .getObjectsByIds([productID]);
    final product = Product.fromJson(products.first.toMap());
    return product;
  }
}
