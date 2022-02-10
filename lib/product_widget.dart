import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final Color tintColor = Color(0xFF23263B);

  String? _selectedSize = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("")),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topLeft,
                        children: <Widget>[
                          Container(
                              decoration:
                                  new BoxDecoration(color: Colors.white),
                              alignment: Alignment.center,
                              height: 300,
                              child: Image.network(widget.product.image_urls[0],
                                  fit: BoxFit.cover)),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(children: <Widget>[
                            SizedBox(
                                width: double.infinity,
                                child: Text(widget.product.brand,
                                    style: TextStyle(
                                        height: 1,
                                        fontSize: 14,
                                        fontFamily: "Inter"),
                                    textAlign: TextAlign.left)),
                            SizedBox(height: 10),
                            SizedBox(
                                width: double.infinity,
                                child: Text(widget.product.name,
                                    style: TextStyle(
                                        height: 1,
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left)),
                            SizedBox(height: 10),
                            widget.product.oneSize
                                ? SizedBox.shrink()
                                : _sizesGrid(
                                    widget.product,
                                    _selectedSize,
                                    (size) => {
                                          setState(() {
                                            _selectedSize = size;
                                          })
                                        }),
                            SizedBox(height: 10),
                            _priceRow(widget.product.price),
                            SizedBox(height: 10),
                            Container(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: tintColor),
                                  onPressed: () => {},
                                  child: Text("Add to Bag")),
                            ),
                            Container(
                              child: OutlinedButton(
                                  onPressed: () => {},
                                  style: OutlinedButton.styleFrom(
                                    primary: tintColor,
                                    side: BorderSide(
                                        width: 1.0,
                                        color: tintColor,
                                        style: BorderStyle.solid),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.favorite_border),
                                        SizedBox(width: 12),
                                        Text("Favorite"),
                                      ])),
                            )
                          ])),
                    ]))));
  }

  Widget _sizesGrid(
      Product product, String? selectedSize, Function(String) didSelectSize) {
    return SizedBox(
        height: 200,
        child: GridView.count(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: 4,
            childAspectRatio: 4 / 2,
            children: List.generate(product.available_sizes.length, (index) {
              String size = product.available_sizes[index];
              bool isSelected = size == selectedSize;
              if (isSelected) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: tintColor),
                    onPressed: () => {didSelectSize(size)},
                    child: Text(size));
              } else {
                return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: tintColor,
                      side: BorderSide(
                          width: 1.0,
                          color: tintColor,
                          style: BorderStyle.solid),
                    ),
                    onPressed: () => {didSelectSize(size)},
                    child: Text(size));
              }
            })));
  }

  String formatPriceValue(double price) {
    return price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2);
  }

  Widget _priceRow(Price price) {
    return SizedBox(
        child: Row(
      children: [
        if (price.isDiscounted)
          Container(
            decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.all(Radius.circular(2))),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              "${price.discount_level}% OFF",
              style: TextStyle(backgroundColor: Colors.tealAccent),
            ),
          ),
        if (price.isDiscounted)
          Text(
            "${formatPriceValue(price.discounted_value)} €",
            style: TextStyle(
                color: Colors.grey, decoration: TextDecoration.lineThrough),
          ),
        Text("${formatPriceValue(price.value)} €",
            style: TextStyle(color: Colors.deepPurpleAccent)),
      ],
    ));
  }
}
