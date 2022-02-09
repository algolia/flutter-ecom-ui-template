class Product {
  final String name;
  final String brand;
  final List<String> image_urls;
  final List<String> available_sizes;
  final Price price;
  Product(
      this.name, this.brand, this.image_urls, this.available_sizes, this.price);

  String get image_url => image_urls[0];
  bool get oneSize =>
      available_sizes.length == 1 && available_sizes.first == "one size";

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      json['name'],
      json['brand'],
      List<String>.from(json['image_urls']),
      List<String>.from(json['available_sizes']),
      Price.fromJson(json['price']),
    );
  }
}

class Price {
  final String currency;
  final double discount_level;
  final double discounted_value;
  final bool on_sales;
  final double value;

  bool get isDiscounted => discounted_value != 0;

  Price(this.currency, this.discount_level, this.discounted_value,
      this.on_sales, this.value);

  static Price fromJson(Map<String, dynamic> json) {
    return Price(
      json['currency'],
      json['discount_level'].toDouble(),
      json['discounted_value'].toDouble(),
      json['on_sales'],
      json['value'].toDouble(),
    );
  }
}
