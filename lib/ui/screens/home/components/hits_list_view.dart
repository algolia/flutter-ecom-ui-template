import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/ui/screens/home/components/products_view.dart';

class HitsListView extends StatelessWidget {
  const HitsListView(
      {Key? key,
      required this.items,
      required this.productWidget,
      this.scrollDirection = Axis.vertical})
      : super(key: key);

  final List<Product> items;
  final ProductWidgetBuilder productWidget;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(8),
        scrollDirection: scrollDirection,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return productWidget(context, items[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10));
  }
}
