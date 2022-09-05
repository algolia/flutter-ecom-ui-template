import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/ui/screens/home/components/home_banner_view.dart';
import 'package:flutter_ecom_demo/ui/screens/product/product_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/search/autocomplete_screen.dart';
import 'package:flutter_ecom_demo/ui/widgets/app_bar_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/product_card_view.dart';

import 'components/products_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productRepository = ProductRepository();

  void _presentProductPage(BuildContext context, String productID) {
    _productRepository.getProduct(productID).then((product) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ProductScreen(product: product),
        )));
  }

  void _presentAutoComplete(BuildContext context) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AutocompleteScreen(),
          fullscreenDialog: true,
        ));
  }

  Widget _productView(BuildContext context, Product product) {
    return ProductCardView(
        product: product,
        imageAlignment: Alignment.bottomCenter,
        onTap: (objectID) => _presentProductPage(context, objectID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarView(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.5)),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.menu),
                              label: const Text("MENU")),
                        ),
                        VerticalDivider(
                            width: 20,
                            indent: 12,
                            endIndent: 12,
                            thickness: 1,
                            color: Colors.grey.withOpacity(0.5)),
                        Flexible(
                          child: TextField(
                            readOnly: true,
                            onTap: () => _presentAutoComplete(context),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.search,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                hintText:
                                    "Search products, articles, faq, ..."),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeBannerView(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Column(
                      children: [
                        ProductsView(
                            title: 'New in shoes',
                            items: _productRepository.shoes,
                            productWidget: _productView),
                        ProductsView(
                            title: 'Spring/Summer 2021',
                            items: _productRepository.seasonalProducts,
                            productWidget: _productView),
                        ProductsView(
                            title: 'Recommended for you',
                            items: _productRepository.recommendedProducts,
                            productWidget: _productView),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
