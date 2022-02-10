import 'package:flutter_ecom_demo/domain/product.dart';
import 'package:flutter_ecom_demo/domain/query.dart';
import 'firebase_client.dart';
import 'algolia_client.dart';

class ProductRepository {
  ProductRepository(this._client);

  final AlgoliaAPIClient _client;
  final firebaseClient = FirebaseClient();

  Future<List<Product>> getProducts(String query) async {
    var response = await _client.search(Query(query));
    var hits = response['hits'] as List;
    return List<Product>.from(hits.map((hit) => Product.fromJson(hit)));
  }

  Future<Product> getProduct(String productID) async {
    return firebaseClient.get(productID);
  }

  Future<List<Product>> getSeasonalProducts() async {
    var response = await _client
        .search(Query('', ruleContexts: ['home-spring-summer-2021']));
    var hits = response['hits'] as List;
    return List<Product>.from(hits.map((hit) => Product.fromJson(hit)));
  }
}
