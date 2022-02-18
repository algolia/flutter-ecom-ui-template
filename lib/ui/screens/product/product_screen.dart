import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/ui/app_theme.dart';
import 'package:flutter_ecom_demo/ui/screens/product/components/image_slider_view.dart';
import 'package:flutter_ecom_demo/ui/screens/product/components/price_row_view.dart';
import 'package:flutter_ecom_demo/ui/screens/product/components/sizes_grid_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/app_bar_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/rating_view.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String? _selectedSize;
  int currentPage = 1;

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();
    _selectedSize = product.oneSize ? null : product.sizes!.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarView(),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              ImageSliderView(product: product),
              Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: <Widget>[
                    SizedBox(
                        width: double.infinity,
                        child: Text(product.brand ?? "",
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left)),
                    const SizedBox(height: 10),
                    SizedBox(
                        width: double.infinity,
                        child: Text(product.name ?? "",
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left)),
                    const SizedBox(height: 10),
                    RatingView(
                        value: product.reviews?.rating?.toInt() ?? 0,
                        reviewsCount: product.reviews?.count?.toInt() ?? 0,
                        iconSize: 12,
                        fontSize: 12,
                        isExtended: true),
                    const SizedBox(height: 10),
                    PriceRowView(price: product.price!),
                    const SizedBox(height: 10),
                    product.oneSize
                        ? const SizedBox.shrink()
                        : SizesGridView(
                            product: product,
                            selectedSize: _selectedSize,
                            didSelectSize: (size) => setState(() {
                                  _selectedSize = size;
                                })),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppTheme.darkBlue),
                          onPressed: () => {},
                          child: const Text("Add to Bag")),
                    ),
                    OutlinedButton(
                        onPressed: () => {},
                        style: OutlinedButton.styleFrom(
                          primary: AppTheme.darkBlue,
                          side: const BorderSide(
                              width: 1.0,
                              color: AppTheme.darkBlue,
                              style: BorderStyle.solid),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.favorite_border),
                              SizedBox(width: 12),
                              Text("Favorite"),
                            ]))
                  ])),
            ])));
  }
}
