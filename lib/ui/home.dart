import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/algolia_client.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/domain/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productRepository = ProductRepository(AlgoliaAPIClient("latency",
      "927c3fe76d4b52c5a2912973f35a3077", "STAGING_native_ecom_demo_products"));

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
    final shoes = await _productRepository.getProducts('shoes');
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
    final products = await _productRepository.getProducts('jacket');
    setState(() {
      _recommended = products;
    });
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
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("TBD"),
                              ));
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.search),
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
                                  return ProductView(
                                      product: _newInShoes[index],
                                      imageAlignment: Alignment.bottomCenter,
                                      onProductPressed: (objectID) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Navigate to $objectID: TBD"),
                                        ));
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
                                  return ProductView(
                                    product: _seasonal[index],
                                    onProductPressed: (objectID) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Navigate to $objectID: TBD"),
                                      ));
                                    },
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
                                  return ProductView(
                                    product: _recommended[index],
                                    onProductPressed: (objectID) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Navigate to $objectID: TBD"),
                                      ));
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
            style: TextStyle(color: Color(0xFF5468FF)),
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

class IconLabel extends StatelessWidget {
  const IconLabel({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(icon),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(text, style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView(
      {Key? key,
      required this.product,
      this.imageAlignment = Alignment.center,
      this.onProductPressed})
      : super(key: key);

  final Product product;
  final Alignment imageAlignment;
  final ValueChanged<String>? onProductPressed;

  @override
  Widget build(BuildContext context) {
    final priceValue = (product.price?.onSales ?? false)
        ? product.price?.discountedValue
        : product.price?.value;
    final crossedValue =
        (product.price?.onSales ?? false) ? product.price?.value : null;
    return GestureDetector(
      onTap: () {
        onProductPressed?.call(product.objectID!);
      },
      child: SizedBox(
        width: 150,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Image.network('${product.image}',
                  alignment: imageAlignment, fit: BoxFit.cover)),
          const SizedBox(height: 8),
          SizedBox(
              child: Text('${product.brand}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.caption)),
          SizedBox(
              child: Text('${product.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodyText2)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Color(int.parse(product.color!.hexColor()!, radix: 16)),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ))),
          ),
          Row(
            children: [
              Text('$priceValue €',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE8600A))),
              if (crossedValue != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('$crossedValue €',
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(decoration: TextDecoration.lineThrough)),
                ),
            ],
          ),
          Row(
            children: [
              StarDisplay(value: product.reviews?.rating?.toInt() ?? 0),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text('(${product.reviews?.count})',
                    style: const TextStyle(fontSize: 8)),
              )
            ],
          )
        ]),
      ),
    );
  }
}

class StarDisplay extends StatelessWidget {
  const StarDisplay({Key? key, this.value = 0, this.size = 8})
      : super(key: key);

  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          size: size,
        );
      }),
    );
  }
}
