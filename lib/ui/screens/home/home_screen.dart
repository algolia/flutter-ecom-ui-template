import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_searcher.dart';
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
  final _latest = ProductsSearcher(query: "shoes");
  final _seasonal = ProductsSearcher(contexts: ["home-spring-summer-2021"]);
  final _recommended = ProductsSearcher(query: "jacket");

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
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeBannerView(),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Column(
                  children: [
                    _productsView(_latest, 'New in shoes'),
                    _productsView(_seasonal, 'Spring/Summer 2021'),
                    _productsView(_recommended, 'Recommended for you'),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  StreamBuilder<List<Product>> _productsView(
      ProductsSearcher searcher, String title) {
    return StreamBuilder<List<Product>>(
      stream: searcher.hits,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data ?? [];
          return ProductsView(
              title: title,
              items: products,
              productWidget: (context, product) => ProductCardView(
                  product: product,
                  imageAlignment: Alignment.bottomCenter,
                  onTap: (objectID) => _presentProductPage(context, objectID)));
        } else {
          // no values yet
          return const CircularProgressIndicator();
        }
      },
    );
  }

  void _presentProductPage(BuildContext context, String productID) {
    _latest.getById(productID).then((product) => Navigator.push(
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

  @override
  void dispose() {
    super.dispose();
    _latest.dispose();
    _seasonal.dispose();
    _recommended.dispose();
  }
}
