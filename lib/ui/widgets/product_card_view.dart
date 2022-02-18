import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/ui/app_theme.dart';
import 'package:flutter_ecom_demo/ui/widgets/color_indicator_view.dart';
import 'package:flutter_ecom_demo/ui/widgets/rating_view.dart';

class ProductCardView extends StatelessWidget {
  const ProductCardView(
      {Key? key,
      required this.product,
      this.imageAlignment = Alignment.center,
      this.onTap})
      : super(key: key);

  final Product product;
  final Alignment imageAlignment;
  final Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    final priceValue = (product.price?.onSales ?? false)
        ? product.price?.discountedValue
        : product.price?.value;
    final crossedValue =
        (product.price?.onSales ?? false) ? product.price?.value : null;
    return GestureDetector(
      onTap: () => onTap?.call(product.objectID!),
      child: SizedBox(
        width: 150,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network('${product.image}',
                      alignment: imageAlignment, fit: BoxFit.cover)),
              if (product.price?.onSales == true)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(" ON SALE ${product.price?.discountLevel}% ",
                      style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Colors.white,
                          backgroundColor: AppTheme.darkPink)),
                )
            ],
          ),
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
            child: ColorIndicatorView(product: product),
          ),
          Row(
            children: [
              Text('$priceValue €',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.vividOrange)),
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
          RatingView(
              value: product.reviews?.rating?.toInt() ?? 0,
              reviewsCount: product.reviews?.count?.toInt() ?? 0),
        ]),
      ),
    );
  }
}
