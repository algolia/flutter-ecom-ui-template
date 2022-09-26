import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../model/product.dart';
import '../../../widgets/product_item_view.dart';

class PagedHitsListView extends StatelessWidget {
  const PagedHitsListView(
      {Key? key,
      required this.pagingController,
      this.onHitClick,
      this.noItemsFound})
      : super(key: key);

  final PagingController<int, Product> pagingController;
  final Function(String)? onHitClick;
  final WidgetBuilder? noItemsFound;

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Product>.separated(
      shrinkWrap: true,
      pagingController: pagingController,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        noItemsFoundIndicatorBuilder: noItemsFound,
        itemBuilder: (context, item, index) => ProductItemView(
            product: item,
            imageAlignment: Alignment.bottomCenter,
            onProductPressed: (objectID) => onHitClick?.call(objectID)),
      ),
    );
  }
}
