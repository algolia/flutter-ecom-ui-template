
class Product {
  final String name;
  final String brand;
  final List<String> image_urls;

  Product(this.name, this.brand, this.image_urls);

  static Product fromJson(Map<String, dynamic> json) {
    return Product(json['name'], json['brand'], List<String>.from(json['image_urls']));
  }

}