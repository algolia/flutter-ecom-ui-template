import 'package:algolia/algolia.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

import '../credentials.dart';
import '../model/product.dart';

/// The `ProductRepository` component implements the repository design pattern
/// and includes methods to fetch product information.
/// It encapsulates the Algolia Helpers for Flutter and Algolia client.
class ProductRepository {
  /// Hits Searcher with static search query `shoes`.
  final _shoesSearcher = HitsSearcher.create(
    applicationID: Credentials.applicationID,
    apiKey: Credentials.searchOnlyKey,
    state: const SearchState(
      indexName: Credentials.hitsIndex,
      query: 'shoes',
    ),
  );

  /// Hits Searcher with static rule contexts `home-spring-summer-2021`.
  final _seasonalProductsSearcher = HitsSearcher.create(
    applicationID: Credentials.applicationID,
    apiKey: Credentials.searchOnlyKey,
    state: const SearchState(
      indexName: Credentials.hitsIndex,
      ruleContexts: ['home-spring-summer-2021'],
    ),
  );

  /// Hits Searcher with static search query `jacket`.
  final _recommendedProductsSearcher = HitsSearcher.create(
    applicationID: Credentials.applicationID,
    apiKey: Credentials.searchOnlyKey,
    state: const SearchState(
      indexName: Credentials.hitsIndex,
      query: 'jacket',
    ),
  );

  /// Algolia API client instance.
  final Algolia _algoliaClient = const Algolia.init(
    applicationId: Credentials.applicationID,
    apiKey: Credentials.searchOnlyKey,
  );

  /// Disposable components composite
  final CompositeDisposable _components = CompositeDisposable();

  /// Product repository constructor.
  ProductRepository() {
    _components
      ..add(_shoesSearcher)
      ..add(_seasonalProductsSearcher)
      ..add(_recommendedProductsSearcher);
  }

  /// Get stream of shoes.
  Stream<List<Product>> get shoes => _shoesSearcher.responses
      .map((response) => response.hits.map(Product.fromJson).toList());

  /// Get stream of seasonal products.
  Stream<List<Product>> get seasonalProducts =>
      _seasonalProductsSearcher.responses
          .map((response) => response.hits.map(Product.fromJson).toList());

  /// Get stream of recommended products.
  Stream<List<Product>> get recommendedProducts =>
      _recommendedProductsSearcher.responses.map((response) =>
          response.hits.map((hit) => Product.fromJson(hit)).toList());

  /// Get product by ID.
  Future<Product> getProduct(String productID) async {
    List<AlgoliaObjectSnapshot> products = await _algoliaClient.instance
        .index(Credentials.hitsIndex)
        .getObjectsByIds([productID]);
    final product = Product.fromJson(products.first.toMap());
    return product;
  }

  /// Dispose of underlying resources.
  void dispose() {
    _components.dispose();
  }
}
