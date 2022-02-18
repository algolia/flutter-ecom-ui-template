import 'package:flutter_ecom_demo/model/product.dart';

class SearchResponse {
  final List<Product>? hits;
  final num? page;
  final num? nbHits;
  final num? nbPages;
  final num? hitsPerPage;

  SearchResponse(
      {this.hits, this.page, this.nbHits, this.nbPages, this.hitsPerPage});

  static SearchResponse fromJson(Map<String, dynamic> json) {
    final hits = json['hits'] as List;
    return SearchResponse(
      hits: List<Product>.from(hits.map((hit) => Product.fromJson(hit))),
      page: json['page'],
      nbHits: json['nbHits'],
      nbPages: json['nbPages'],
      hitsPerPage: json['hitsPerPage'],
    );
  }
}
