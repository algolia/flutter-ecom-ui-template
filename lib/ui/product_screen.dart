import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/domain/product.dart';
import 'package:flutter_ecom_demo/ui/widgets/icon_label.dart';
import 'package:flutter_ecom_demo/ui/widgets/rating_display.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

final Color tintColor = Color(0xFF23263B);

class _ProductScreenState extends State<ProductScreen> {

  String? _selectedSize;
  int currentPage = 1;

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();
    _selectedSize = product.oneSize ? null : product.sizes!.first;
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
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
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      decoration: new BoxDecoration(color: Colors.white),
                      alignment: Alignment.centerLeft,
                      height: 300,
                      child: _imagesGallery(product, pageController)),
                  Positioned(
                      left: 0,
                      top: 0,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, size: 20),
                      )),
                  Positioned(
                      left: 16,
                      bottom: 24,
                      child: Text(
                          "${currentPage}/${product.images?.length ?? 0}",
                          style: TextStyle(
                              color: tintColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w800))),
                  Positioned.fill(
                      bottom: 24,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _buildPageIndicator())),
                ],
              ),
              Container(
                  padding: EdgeInsets.all(16),
                  child: Column(children: <Widget>[
                    SizedBox(
                        width: double.infinity,
                        child: Text(product.brand ?? "",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left)),
                    SizedBox(height: 10),
                    SizedBox(
                        width: double.infinity,
                        child: Text(product.name ?? "",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left)),
                    SizedBox(height: 10),
                    RatingDisplay(
                        value: product.reviews?.rating?.toInt() ?? 0,
                        reviewsCount: product.reviews?.count?.toInt() ?? 0,
                        iconSize: 12,
                        fontSize: 12,
                        isExtended: true),
                    SizedBox(height: 10),
                    _priceRow(product.price!),
                    SizedBox(height: 10),
                    product.oneSize
                        ? SizedBox.shrink()
                        : _sizesGrid(
                            product,
                            _selectedSize,
                            (size) => {
                                  setState(() {
                                    _selectedSize = size;
                                  })
                                }),
                    SizedBox(height: 10),
                    Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: tintColor),
                          onPressed: () => {},
                          child: Text("Add to Bag")),
                    ),
                    Container(
                      child: OutlinedButton(
                          onPressed: () => {},
                          style: OutlinedButton.styleFrom(
                            primary: tintColor,
                            side: BorderSide(
                                width: 1.0,
                                color: tintColor,
                                style: BorderStyle.solid),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border),
                                SizedBox(width: 12),
                                Text("Favorite"),
                              ])),
                    )
                  ])),
            ]))));
  }

  Widget _imagesGallery(Product product, PageController pageController) {
    final imagesWidgets = List.generate(
        product.images?.length ?? 0,
        (index) => Container(
            width: 400,
            child: Image.network(product.images?[index] ?? "",
                fit: BoxFit.fitHeight)));
    return PageView(
      controller: pageController,
      children: imagesWidgets,
      onPageChanged: (page) => setState(() {
        currentPage = page + 1;
      }),
    );
  }

  Widget _sizesGrid(Product product, String? selectedSize, Function(String) didSelectSize) {
    final sizesCount = product.sizes?.length ?? 0;
    final rowsCount = sizesCount / 4 + (sizesCount % 4 == 0 ? 0 : 1);
    return Container(
        height: rowsCount * 50,
        child: GridView.count(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: 4,
            childAspectRatio: 4 / 2,
            children: List.generate(sizesCount, (index) {
              String size = product.sizes?[index] ?? "";
              bool isSelected = size == selectedSize;
              if (isSelected) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: tintColor),
                    onPressed: () => {didSelectSize(size)},
                    child: Text(size));
              } else {
                return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: tintColor,
                      side: BorderSide(
                          width: 1.0,
                          color: tintColor,
                          style: BorderStyle.solid),
                    ),
                    onPressed: () => {didSelectSize(size)},
                    child: Text(size));
              }
            })));
  }

  String formatPriceValue(num price) {
    return price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2);
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 8 : 8,
        width: isActive ? 8 : 8,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? tintColor : Color(0x00000000),
            border: isActive ? null : Border.all(color: Colors.grey, width: 1)),
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < (product.images?.length ?? 0); i++) {
      list.add(i == currentPage - 1 ? _indicator(true) : _indicator(false));
    }
    return Row(
      children: list,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _priceRow(Price price) {
    return SizedBox(
        child: Row(
      children: [
        if (price.isDiscounted) ...[
          Container(
            decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.all(Radius.circular(2))),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              "${price.discountLevel ?? 0}% OFF",
              style: TextStyle(
                color: Colors.black87,
                backgroundColor: Colors.tealAccent,
                fontSize: 12,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Spacer(),
          Text(
            "${formatPriceValue(price.discountedValue ?? 0)} €",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.lineThrough),
          ),
          SizedBox(width: 16),
        ],
        if (!price.isDiscounted) Spacer(),
        Text("${formatPriceValue(price.value ?? 0)} €",
            style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700)),
      ],
    ));
  }
}
