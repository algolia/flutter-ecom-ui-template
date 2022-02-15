import 'package:flutter_ecom_demo/domain/product.dart';
import 'package:flutter_ecom_demo/domain/query.dart';
import 'package:flutter_ecom_demo/domain/search_response.dart';

import 'algolia_client.dart';
import 'firebase_client.dart';

class ProductRepository {
  ProductRepository._internal();

  static final ProductRepository _instance = ProductRepository._internal();

  factory ProductRepository() {
    return _instance;
  }

  final AlgoliaAPIClient _client = AlgoliaAPIClient("latency",
      "927c3fe76d4b52c5a2912973f35a3077", "STAGING_native_ecom_demo_products");
  final firebaseClient = FirebaseClient();

  Future<List<Product>> getProducts(Query query) async {
    var response = await searchProducts(query);
    return response.hits ?? List.empty();
  }

  Future<Product> getProduct(String productID) async {
    return firebaseClient.get(productID);
  }

  Future<List<Product>> getSeasonalProducts() async {
    var response = await searchProducts(
        Query('', ruleContexts: ['home-spring-summer-2021']));
    return response.hits ?? List.empty();
  }

  Future<SearchResponse> searchProducts(Query query) async {
    final response = await _client.search(query) as Map<String, dynamic>;
    return SearchResponse.fromJson(response);
  }
}
