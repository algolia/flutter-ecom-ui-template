import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/ui/app_theme.dart';
import 'package:flutter_ecom_demo/ui/widgets/product_card_view.dart';

typedef ProductWidgetBuilder = Widget Function(
    BuildContext context, Product product);

class ProductsView extends StatelessWidget {
  const ProductsView({
    Key? key,
    required this.title,
    required this.items,
    required this.productWidget,
  }) : super(key: key);

  final String title;
  final List<Product> items;
  final ProductWidgetBuilder productWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            height: 200.0,
            child: ListView.separated(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return productWidget(context, items[index]);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 10)))
      ],
    );
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
            style: TextStyle(color: AppTheme.nebula),
          ),
        )
      ],
    );
  }
}
