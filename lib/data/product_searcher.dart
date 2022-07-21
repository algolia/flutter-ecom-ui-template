import 'dart:async';

import 'package:algolia_helper/algolia_helper.dart';
import 'package:flutter_ecom_demo/model/product.dart';

import '../credentials.dart';
import '../model/page.dart';

class ProductsSearcher {
  ProductsSearcher({String? query, List<String>? contexts})
      : _helper = AlgoliaHelper.create(
          applicationID: Credentials.applicationID,
          apiKey: Credentials.searchOnlyKey,
          indexName: Credentials.hitsIndex,
          state: SearchState(query: query, ruleContexts: contexts),
        );

  final AlgoliaHelper _helper;

  Stream<List<Product>> get hits => _helper.responses.asyncMap((response) =>
      response.hits.map((hit) => Product.fromJson(hit.json)).toList());

  StreamSubscription<SearchResponse> paginate(
      {required Function(Page<Product> page) onNextPage,
      Function(dynamic error)? onError}) {
    return _helper.responses.listen((response) {
      final page = Page.from(response, (hit) => Product.fromJson(hit.json));
      onNextPage(page);
    }, onError: onError);
  }

  void query(String query) {
    _helper.query(query);
  }

  void page(int page) {
    _helper.setPage(page);
  }

  Future<Product> getById(String productID) async {
    var products = await _helper.client
        .index(Credentials.hitsIndex)
        .getObjectsByIds([productID]);
    final product = Product.fromJson(products.first.toMap());
    return product;
  }

  void dispose() {
    _helper.dispose();
  }
}
