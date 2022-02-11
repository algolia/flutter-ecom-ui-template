import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/domain/product.dart';

class ColorIndicator extends StatelessWidget {
  const ColorIndicator({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final isMultiColor = product.color?.originalName == 'multi';
    return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: !isMultiColor
                ? Color(int.parse(product.color!.hexColor()!, radix: 16))
                : null,
            border: Border.all(
              width: 1,
              color: Colors.grey,
              style: BorderStyle.solid,
            ),
            image: isMultiColor
                ? const DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/color_wheel.png'))
                : null));
  }
}
