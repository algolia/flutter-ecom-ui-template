import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/ui/screens/home/components/home_banner_view.dart';
import 'package:flutter_ecom_demo/ui/screens/product/product_screen.dart';
import 'package:flutter_ecom_demo/ui/screens/search/autocomplete_screen.dart';
import 'package:flutter_ecom_demo/ui/widgets/app_bar_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/product_card_view.dart';
import 'package:provider/provider.dart';

import 'components/products_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _presentProductPage(BuildContext context, String productID,
      ProductRepository productRepository) {
    productRepository.getProduct(productID).then((product) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ProductScreen(product: product),
        )));
  }

  void _presentAutoComplete(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const AutocompleteScreen(),
      fullscreenDialog: true,
    ));
  }

  Widget _productView(BuildContext context, Product product) {
    return Consumer<ProductRepository>(
        builder: (context, productRepository, child) {
      return ProductCardView(
          product: product,
          imageAlignment: Alignment.bottomCenter,
          onTap: (objectID) =>
              _presentProductPage(context, objectID, productRepository));
    });
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
                      child: Consumer<ProductRepository>(
                          builder: (context, productRepository, child) {
                        return Column(
                          children: [
                            ProductsView(
                                title: 'New in shoes',
                                items: productRepository.shoes,
                                productWidget: _productView),
                            ProductsView(
                                title: 'Spring/Summer 2021',
                                items: productRepository.seasonalProducts,
                                productWidget: _productView),
                            ProductsView(
                                title: 'Recommended for you',
                                items: productRepository.recommendedProducts,
                                productWidget: _productView),
                          ],
                        );
                      })),
                ],
              ),
            )));
  }
}
