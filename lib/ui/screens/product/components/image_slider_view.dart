import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/model/product.dart';
import 'package:flutter_ecom_demo/ui/app_theme.dart';

class ImageSliderView extends StatefulWidget {
  const ImageSliderView({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  _ImageSliderViewState createState() => _ImageSliderViewState();
}

class _ImageSliderViewState extends State<ImageSliderView> {
  Product get product => widget.product;
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return Stack(
      children: <Widget>[
        Container(
            decoration: const BoxDecoration(color: Colors.white),
            alignment: Alignment.centerLeft,
            height: 300,
            child: _imagesGallery(product, pageController)),
        Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20),
            )),
        Positioned(
            left: 16,
            bottom: 24,
            child: Text("$currentPage/${product.images?.length ?? 0}",
                style: const TextStyle(
                    color: AppTheme.darkBlue,
                    fontSize: 9,
                    fontWeight: FontWeight.w800))),
        Positioned.fill(
            bottom: 24,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildPageIndicator())),
      ],
    );
  }

  Widget _imagesGallery(Product product, PageController pageController) {
    final imagesWidgets = List.generate(
        product.images?.length ?? 0,
        (index) => SizedBox(
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

  Widget _indicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 8 : 8,
        width: isActive ? 8 : 8,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.darkBlue : Colors.transparent,
            border: isActive ? null : Border.all(color: Colors.grey, width: 1)),
      ),
    );
  }
}
