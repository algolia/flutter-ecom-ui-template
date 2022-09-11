import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/ui/screens/home/components/section_header.dart';
import 'package:flutter_ecom_demo/ui/screens/home/components/hits_list_view.dart';

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
  final Stream<List<Product>> items;
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
            child: HitsListView(
                items: items,
                productWidget: productWidget,
                scrollDirection: Axis.horizontal))
      ],
    );
  }
}