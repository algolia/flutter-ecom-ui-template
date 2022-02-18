import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/product.dart';

class PriceRowView extends StatelessWidget {
  const PriceRowView({Key? key, required this.price}) : super(key: key);

  final Price price;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Row(
      children: [
        if (price.isDiscounted) ...[
          Container(
            decoration: const BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.all(Radius.circular(2))),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              "${price.discountLevel ?? 0}% OFF",
              style: const TextStyle(
                color: Colors.black87,
                backgroundColor: Colors.tealAccent,
                fontSize: 12,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(),
          Text(
            "${formatPriceValue(price.discountedValue ?? 0)} €",
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.lineThrough),
          ),
          const SizedBox(width: 16),
        ],
        if (!price.isDiscounted) const Spacer(),
        Text("${formatPriceValue(price.value ?? 0)} €",
            style: const TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700)),
      ],
    ));
  }

  String formatPriceValue(num price) {
    return price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2);
  }
}
