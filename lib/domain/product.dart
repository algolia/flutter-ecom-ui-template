class Product {
  final String? objectID;
  final String? name;
  final String? brand;
  final String? image;
  final Price? price;
  final Reviews? reviews;
  final ProductColor? color;

  Product(
      {this.objectID,
      this.name,
      this.image,
      this.brand,
      this.price,
      this.reviews,
      this.color});

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
        objectID: json['objectID'],
        name: json['name'],
        image: json['image_urls'][0],
        brand: json['brand'],
        price: Price.fromJson(json['price']),
        reviews: Reviews.fromJson(json['reviews']),
        color: ProductColor.fromJson(json['color']));
  }

  @override
  String toString() {
    return 'Product{objectID: $objectID, name: $name, brand: $brand, image: $image, price: $price, reviews: $reviews}';
  }
}

class Price {
  final String? currency;
  final num? value;
  final num? discountedValue;
  final num? discountLevel;
  final bool? onSales;

  Price(
      {this.currency,
      this.value,
      this.discountedValue,
      this.discountLevel,
      this.onSales});

  static Price fromJson(Map<String, dynamic> json) {
    return Price(
      currency: json['currency'],
      value: json['value'],
      discountedValue: json['discounted_value'],
      discountLevel: json['discount_level'],
      onSales: json['on_sales'],
    );
  }

  @override
  String toString() {
    return 'Price{currency: $currency, value: $value, discountedValue: $discountedValue, discountLevel: $discountLevel, onSale: $onSales}';
  }
}

class Reviews {
  final num? rating;
  final num? count;

  Reviews({this.rating, this.count});

  static Reviews fromJson(Map<String, dynamic> json) {
    return Reviews(rating: json['rating'], count: json['count']);
  }
}

class ProductColor {
  final String? filterGroup;
  final String? originalName;

  ProductColor({this.filterGroup, this.originalName});

  String? hexColor() {
    final hexString = filterGroup?.split(';')[1];
    if (hexString == null) return null;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('FF');
    buffer.write(hexString.replaceFirst('#', ''));
    return buffer.toString();
  }

  static ProductColor fromJson(Map<String, dynamic> json) {
    return ProductColor(
        filterGroup: json['filter_group'], originalName: json['original_name']);
  }
}
