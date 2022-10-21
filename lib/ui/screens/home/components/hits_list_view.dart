import 'package:flutter/material.dart';

import '../../../../model/product.dart';
import 'products_view.dart';

class HitsListView extends StatelessWidget {
  const HitsListView(
      {Key? key,
      required this.items,
      required this.productWidget,
      this.scrollDirection = Axis.vertical})
      : super(key: key);

  final Stream<List<Product>> items;
  final ProductWidgetBuilder productWidget;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: items,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data ?? [];
          return ListView.separated(
              padding: const EdgeInsets.all(8),
              scrollDirection: scrollDirection,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return productWidget(context, products[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
