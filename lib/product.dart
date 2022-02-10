
class Product {
  final String name;
  final String brand;

  Product(this.name, this.brand);

  static Product fromJson(Map<String, dynamic> json) {
    return Product(json['name'], json['brand']);
  }

}