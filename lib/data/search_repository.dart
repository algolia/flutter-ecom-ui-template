import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_ecom_demo/model/sort_index.dart';

import '../credentials.dart';
import '../model/product.dart';
import '../model/search_metadata.dart';

class SearchRepository {
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

  /// Disposable components composite.
  final CompositeDisposable _components = CompositeDisposable();

  /// Search repository constructor.
  SearchRepository() {
    _components
      ..add(_filterState)
      ..add(_hitsSearcher)
      ..add(_brandFacetList)
      ..add(_sizeFacetList);
  }

  /// Set search page.
  void setPage(int page) {
    _hitsSearcher.applyState((state) => state.copyWith(page: page));
  }

  /// Get products list by query.
  void search(String query) {
    _hitsSearcher.query(query);
  }

  /// Get stream of latest search result
  Stream<SearchMetadata> get searchMetadata =>
      _hitsSearcher.responses.map(SearchMetadata.fromResponse);

  /// Get stream of latest search page
  Stream<ProductsPage> get productsPage =>
      _hitsSearcher.responses.map(ProductsPage.fromResponse);

  Stream<int> get appliedFiltersCount =>
      _filterState.filters.map((event) => event.getFilters().length);

  /// Get currently selected index
  Stream<SortIndex> get selectedIndex =>
      _hitsSearcher.state.map((state) => SortIndex.of(state.indexName));

  /// Update target index
   void selectIndexName(String indexName) {
    _hitsSearcher
        .applyState((state) => state.copyWith(indexName: indexName, page: 0));
  }

  /// Get stream of list of brand facets
  Stream<List<SelectableFacet>> get brandFacets => _brandFacetList.facets;

  /// Get stream of list of size facets
  Stream<List<SelectableFacet>> get sizeFacets => _sizeFacetList.facets;

  /// Toggle selection of a brand facet
  void toggleBrand(String brand) {
    _brandFacetList.toggle(brand);
    _hitsSearcher.applyState((state) => state.copyWith(page: 0));
  }

  /// Toggle selection of a size facet
  void toggleSize(String size) {
    _sizeFacetList.toggle(size);
    _hitsSearcher.applyState((state) => state.copyWith(page: 0));
  }

  /// Clear all filters
  void clearFilters() {
    _filterState.clear();
    _hitsSearcher.applyState((state) => state.copyWith(page: 0));
  }

  /// Dispose of underlying resources.
  void dispose() {
    _components.dispose();
  }
}
