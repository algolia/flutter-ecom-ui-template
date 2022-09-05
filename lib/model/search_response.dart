import 'package:flutter_ecom_demo/model/product.dart';

class SearchResponseB {
  final List<Product>? hits;
  final num? page;
  final num? nbHits;
  final num? nbPages;
  final num? hitsPerPage;

  SearchResponseB(
      {this.hits, this.page, this.nbHits, this.nbPages, this.hitsPerPage});

  static SearchResponseB fromJson(Map<String, dynamic> json) {
    final hits = json['hits'] as List;
    return SearchResponseB(
      hits: List<Product>.from(hits.map((hit) => Product.fromJson(hit))),
      page: json['page'],
      nbHits: json['nbHits'],
      nbPages: json['nbPages'],
      hitsPerPage: json['hitsPerPage'],
    );
  }
}
