import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/domain/product.dart';
import 'package:flutter_ecom_demo/ui/theme_colors.dart';
import 'package:flutter_ecom_demo/ui/widgets/color_indicator.dart';
import 'package:flutter_ecom_demo/ui/widgets/rating_display.dart';

class ProductItemView extends StatelessWidget {
  const ProductItemView(
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
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network('${product.image}',
                      alignment: imageAlignment, fit: BoxFit.cover)),
              if (product.price?.onSales == true)
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      " ON SALE ${product.price?.discountLevel}% ",
                      style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Colors.white,
                          backgroundColor: ThemeColors.darkPink),
                    ))
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${product.brand}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.caption),
                Text('${product.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyText1),
                if (product.description?.isNotEmpty == true)
                  Text('${product.description}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 12, color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: ColorIndicator(product: product),
                ),
                Row(
                  children: [
                    Text('$priceValue €',
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.vividOrange)),
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
                                ?.copyWith(
                                    decoration: TextDecoration.lineThrough)),
                      ),
                  ],
                ),
                RatingDisplay(
                    value: product.reviews?.rating?.toInt() ?? 0,
                    reviewsCount: product.reviews?.count?.toInt() ?? 0),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
