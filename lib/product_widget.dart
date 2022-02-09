import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
        body: Column(children: <Widget>[
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(color: Colors.white),
              alignment: Alignment.center,
              height: 240,
              child: Image.network(widget.product.image_urls[0],
                  fit: BoxFit.fill)),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          )
        ],
      ),
      SizedBox(
          width: double.infinity,
          child: Text(widget.product.brand,
              style: TextStyle(height: 5, fontSize: 14, fontFamily: "Inter"),
              textAlign: TextAlign.left)),
      SizedBox(
          width: double.infinity,
          child: Text(widget.product.name,
              style: TextStyle(
                  height: 5,
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left)),
    ]));
  }
}
