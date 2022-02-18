import 'package:flutter_ecom_demo/credentials.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/model/query.dart';
import 'package:flutter_ecom_demo/model/search_response.dart';

import 'algolia_client.dart';
import 'firebase_client.dart';

/// Products data repository.
class ProductRepository {
  ProductRepository._internal();

  static final ProductRepository _instance = ProductRepository._internal();

  factory ProductRepository() {
    return _instance;
  }

  final AlgoliaAPIClient _client = AlgoliaAPIClient(
      Credentials.applicationID,
      Credentials.searchOnlyKey,
      Credentials.hitsIndex);
  final firebaseClient = FirebaseClient();

  /// Get products list by query.
  Future<List<Product>> getProducts(Query query) async {
    final response = await searchProducts(query);
    return response.hits ?? List.empty();
  }

  /// Get product by ID.
  Future<Product> getProduct(String productID) async {
    return firebaseClient.get(productID);
  }

  /// Get list of seasonal products.
  Future<List<Product>> getSeasonalProducts() async {
    final response = await searchProducts(
        Query('', ruleContexts: ['home-spring-summer-2021']));
    return response.hits ?? List.empty();
  }

  /// Search products by query.
  Future<SearchResponse> searchProducts(Query query) async {
    final response = await _client.search(query) as Map<String, dynamic>;
    return SearchResponse.fromJson(response);
  }
}
