import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/domain/product.dart';
import 'package:flutter_ecom_demo/domain/query.dart';
import 'package:flutter_ecom_demo/ui/autocomplete_screen.dart';
import 'package:flutter_ecom_demo/ui/product_screen.dart';
import 'package:flutter_ecom_demo/ui/theme_colors.dart';
import 'package:flutter_ecom_demo/ui/widgets/icon_label.dart';
import 'package:flutter_ecom_demo/ui/widgets/product_card_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productRepository = ProductRepository();

  List<Product> _newInShoes = [];
  List<Product> _seasonal = [];
  List<Product> _recommended = [];

  @override
  void initState() {
    super.initState();
    setupLatest();
    setupSeasonal();
    setupRecommended();
  }

  Future<void> setupLatest() async {
    final shoes = await _productRepository.getProducts(Query('shoes'));
    setState(() {
      _newInShoes = shoes;
    });
  }

  Future<void> setupSeasonal() async {
    final products = await _productRepository.getSeasonalProducts();
    setState(() {
      _seasonal = products;
    });
  }

  Future<void> setupRecommended() async {
    final products = await _productRepository.getProducts(Query('jacket'));
    setState(() {
      _recommended = products;
    });
  }

  void _presentProductPage(BuildContext context, String productID) {
    _productRepository
        .getProduct(productID)
        .then((product) => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return ProductScreen(product: product);
              },
            )));
  }

  void _presentAutoComplete(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            var theme = Theme.of(context);
            return Theme(data: theme, child: AutocompleteScreen());
          },
          fullscreenDialog: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Image.asset('assets/images/og.png', height: 128),
          actions: const [
            IconLabel(icon: Icons.pin_drop_outlined, text: 'STORES'),
            IconLabel(icon: Icons.person_outline, text: 'ACCOUNTS'),
            IconLabel(icon: Icons.shopping_bag_outlined, text: 'CART')
          ],
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
                          // TODO: revert changes below
                          child: TextField(
                            readOnly: true,
                            onTap: () => _presentAutoComplete(context),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.search,
                                    color: Theme.of(context).primaryColor),
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
              const Banner(),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'New in shoes'),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            height: 200.0,
                            child: ListView.separated(
                                padding: const EdgeInsets.all(8),
                                scrollDirection: Axis.horizontal,
                                itemCount: _newInShoes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductCardView(
                                      product: _newInShoes[index],
                                      imageAlignment: Alignment.bottomCenter,
                                      onProductPressed: (objectID) {
                                        _presentProductPage(context, objectID);
                                      });
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10)))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Spring/Summer 2021'),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            height: 200.0,
                            child: ListView.separated(
                                padding: const EdgeInsets.all(8),
                                scrollDirection: Axis.horizontal,
                                itemCount: _seasonal.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductCardView(
                                    product: _seasonal[index],
                                    onProductPressed: (objectID) =>
                                        _presentProductPage(context, objectID),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10)))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Recommended for you'),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            height: 200.0,
                            child: ListView.separated(
                                padding: const EdgeInsets.all(8),
                                scrollDirection: Axis.horizontal,
                                itemCount: _recommended.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductCardView(
                                    product: _recommended[index],
                                    onProductPressed: (objectID) {
                                      _presentProductPage(context, objectID);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10)))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.title,
    this.onMorePressed,
  }) : super(key: key);

  final String title;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.subtitle2),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See More',
            style: TextStyle(color: ThemeColors.nebula),
          ),
        )
      ],
    );
  }
}

class Banner extends StatelessWidget {
  const Banner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        Container(
          alignment: Alignment.center,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.33), BlendMode.srcOver),
            child: Image.asset(
              'assets/images/banner.jpg',
              height: 128,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New\nCollection'.toUpperCase(),
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Spring/Summer 2021'.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
