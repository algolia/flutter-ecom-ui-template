import 'package:algolia/algolia.dart';
import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/model/query.dart';
import 'package:flutter_ecom_demo/model/search_response.dart';

/// Products data repository.
class ProductRepository {
  ProductRepository._internal();

  static final ProductRepository _instance = ProductRepository._internal();

  factory ProductRepository() {
    return _instance;
  }

  final Algolia _algoliaClient = Algolia.init(
      applicationId: Credentials.applicationID,
      apiKey: Credentials.searchOnlyKey);

  /// Get products list by query.
  Future<List<Product>> getProducts(Query query) async {
    final response = await searchProducts(query);
    return response.hits ?? List.empty();
  }

  /// Get product by ID.
  Future<Product> getProduct(String productID) async {
    List<AlgoliaObjectSnapshot> products = await _algoliaClient.instance
        .index(Credentials.hitsIndex)
        .getObjectsByIds([productID]);
    print(products.first.toMap());
    final product = Product.fromJson(products.first.toMap());
    return product; //firebaseClient.getProduct(productID);
  }

  /// Get list of seasonal products.
  Future<List<Product>> getSeasonalProducts() async {
    final response = await searchProducts(
        Query('', ruleContexts: ['home-spring-summer-2021']));
    return response.hits ?? List.empty();
  }

  /// Search products by query.
  Future<SearchResponse> searchProducts(Query query) async {
    AlgoliaQuery algoliaQuery =
        _algoliaClient.instance.index(Credentials.hitsIndex);
    algoliaQuery = query.apply(algoliaQuery);
    AlgoliaQuerySnapshot snap = await algoliaQuery.getObjects();
    return SearchResponse.fromJson(snap.toMap());
  }
}
