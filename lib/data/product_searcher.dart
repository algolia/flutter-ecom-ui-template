import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:algolia_helper_flutter/algolia.dart';
import 'package:flutter_ecom_demo/model/product.dart';

import '../credentials.dart';
import '../model/page.dart';

class ProductsSearcher {
  ProductsSearcher({String? query, List<String>? contexts})
      : _searcher = HitsSearcher.create(
          applicationID: Credentials.applicationID,
          apiKey: Credentials.searchOnlyKey,
          state: SearchState(
              indexName: Credentials.hitsIndex,
              query: query,
              ruleContexts: contexts),
        ),
        _client = const Algolia.init(
            applicationId: Credentials.applicationID,
            apiKey: Credentials.searchOnlyKey);

  final HitsSearcher _searcher;
  final Algolia _client;

  Stream<List<Product>> get hits => _searcher.responses.asyncMap((response) =>
      response.hits.map((hit) => Product.fromJson(hit.json)).toList());

  StreamSubscription<SearchResponse> paginate(
      {required Function(Page<Product> page) onNextPage,
      Function(dynamic error)? onError}) {
    return _searcher.responses.listen((response) {
      final page = Page.from(response, (hit) => Product.fromJson(hit.json));
      onNextPage(page);
    }, onError: onError);
  }

  void query(String query) {
    _searcher.query(query);
  }

  void page(int page) {
    _searcher.applyState((state) => state.copyWith(page: page));
  }

  Future<Product> getById(String productID) async {
    var products =
        await _client.index(Credentials.hitsIndex).getObjectsByIds([productID]);
    final product = Product.fromJson(products.first.toMap());
    return product;
  }

  void dispose() {
    _searcher.dispose();
  }
}
