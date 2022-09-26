import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../credentials.dart';
import '../model/product.dart';
import '../model/search_metadata.dart';

class SearchRepository {
  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  /// Component holding search filters
  final _filterState = FilterState();

  /// Products Hits Searcher.
  late final _hitsSearcher = HitsSearcher(
    applicationID: Credentials.applicationID,
    apiKey: Credentials.searchOnlyKey,
    indexName: Credentials.hitsIndex,
  )..connectFilterState(_filterState);

  /// Brands facet lists
  late final _brandFacetList = FacetList(
    searcher: _hitsSearcher,
    filterState: _filterState,
    attribute: 'brand',
  );

  /// Size facet lists
  late final _sizeFacetList = FacetList(
    searcher: _hitsSearcher,
    filterState: _filterState,
    attribute: 'available_sizes',
  );

  SearchRepository() {
    pagingController.addPageRequestListener((pageKey) {
      _hitsSearcher.applyState((state) => state.copyWith(page: pageKey));
    });

    _searchPage.listen((page) {
      pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) {
      pagingController.error = error;
    });
  }

  /// Get products list by query.
  void search(String query) {
    pagingController.refresh();
    _hitsSearcher.query(query);
  }

  /// Get stream of latest search result
  Stream<SearchMetadata> get searchMetadata =>
      _hitsSearcher.responses.map(SearchMetadata.fromResponse);

  /// Get stream of latest search page
  Stream<ProductsPage> get _searchPage =>
      _hitsSearcher.responses.map(ProductsPage.fromResponse);

  Stream<int> get appliedFiltersCount =>
      _filterState.filters.map((event) => event.getFilters().length);

  /// Get the name of currently selected index
  Stream<String> get selectedIndexName =>
      _hitsSearcher.state.map((state) => state.indexName);

  /// Update the name of the index to target
  void selectIndexName(String indexName) {
    pagingController.refresh();
    _hitsSearcher.applyState((state) => state.copyWith(indexName: indexName));
  }

  /// Get stream of list of brand facets
  Stream<List<SelectableFacet>> get brandFacets => _brandFacetList.facets;

  /// Get stream of list of size facets
  Stream<List<SelectableFacet>> get sizeFacets => _sizeFacetList.facets;

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

  /// Clear all filters
  void clearFilters() {
    pagingController.refresh();
    _filterState.clear();
  }
}
