import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/product_repository.dart';
import '../../../data/suggestion_repository.dart';
import '../../../model/product.dart';
import '../../widgets/app_bar_view.dart';
import '../../widgets/product_card_view.dart';
import '../product/product_screen.dart';
import '../search/autocomplete_screen.dart';
import 'components/home_banner_view.dart';
import 'components/products_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _presentProductPage(BuildContext context, String productID) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Provider<ProductRepository>(
              create: (_) => ProductRepository(),
              dispose: (_, value) => value.dispose(),
              child: ProductScreen(productID: productID)),
        ));
  }

  void _presentAutoComplete(BuildContext context) =>
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => Provider<SuggestionRepository>(
            create: (_) => SuggestionRepository(),
            dispose: (_, value) => value.dispose(),
            child: const AutocompleteScreen()),
        fullscreenDialog: true,
      ));

  Widget _productView(BuildContext context, Product product) => ProductCardView(
      product: product,
      onTap: (objectID) => _presentProductPage(context, objectID));

  Widget _productsView(
          BuildContext context, String title, Stream<List<Product>> products) =>
      ProductsView(title: title, items: products, productWidget: _productView);

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
                          _productsView(context, 'New in shoes',
                              context.read<ProductRepository>().shoes),
                          _productsView(
                              context,
                              'Spring/Summer 2021',
                              context
                                  .read<ProductRepository>()
                                  .seasonalProducts),
                          _productsView(
                              context,
                              'Recommended for you',
                              context
                                  .read<ProductRepository>()
                                  .recommendedProducts),
                        ],
                      )),
                ],
              ),
            )));
  }
}
