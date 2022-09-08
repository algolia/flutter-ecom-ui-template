import 'package:algolia/algolia.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import '../model/page.dart' as ecom_page;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Products data repository.
class ProductRepository extends ChangeNotifier {
  late FacetList _brandFacetList;
  late FacetList _sizeFacetList;

  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  ProductRepository._internal() {
    _brandFacetList = FacetList(
        searcher: _hitsSearcher, filterState: _filterState, attribute: 'brand');
    _sizeFacetList = FacetList(
        searcher: _hitsSearcher,
        filterState: _filterState,
        attribute: 'available_sizes');
    _hitsSearcher.applyState((state) =>
        state.copyWith(disjunctiveFacets: {'brand', 'available_sizes'}));
    pagingController.addPageRequestListener((pageKey) {
      search((state) => state.copyWith(page: pageKey));
    });
    searchPage.listen((page) {
      pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) {
      pagingController.error = error;
    });
    _hitsSearcher.connectFilterState(_filterState);
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

  void toggleBrand(String brand) {
    pagingController.refresh();
    _brandFacetList.toggle(brand);
  }

  void toggleSize(String size) {
    pagingController.refresh();
    _sizeFacetList.toggle(size);
  }

  void selectIndexName(String indexName) {
    pagingController.refresh();
    _hitsSearcher.applyState((state) => state.copyWith(indexName: indexName));
  }

  void clearFilters() {
    if (_filterState.snapshot().getFilters().isEmpty) {
      return;
    }
    pagingController.refresh();
    _filterState.clear();
  }

  String get selectedIndexName => _hitsSearcher.snapshot().indexName;
  int get appliedFiltersCount => _filterState.snapshot().getFilters().length;

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

  Stream<Filters> get filters => _filterState.filters;

  Stream<ecom_page.Page<Product>> get searchPage =>
      _hitsSearcher.responses.map((response) {
        final isLastPage = response.page == response.nbPages;
        final nextPageKey = isLastPage ? null : response.page + 1;
        return ecom_page.Page(
            response.hits.map((h) => Product.fromJson(h)).toList(),
            nextPageKey);
      });

  Stream<SearchResponse> get searchResult => _hitsSearcher.responses;

  int get brandSelectedFacetsCount => _brandFacetList.snapshot()?.where((element) => element.isSelected).length ?? 0;
  int get sizeSelectedFacetsCount => _sizeFacetList.snapshot()?.where((element) => element.isSelected).length ?? 0;

  Stream<List<SelectableFacet>> get brandFacets => _brandFacetList.facets;
  Stream<List<SelectableFacet>> get sizeFacets => _sizeFacetList.facets;

  /// Get product by ID.
  Future<Product> getProduct(String productID) async {
    List<AlgoliaObjectSnapshot> products = await _algoliaClient.instance
        .index(Credentials.hitsIndex)
        .getObjectsByIds([productID]);
    print(products.first.toMap());
    final product = Product.fromJson(products.first.toMap());
    return product;
  }
}
