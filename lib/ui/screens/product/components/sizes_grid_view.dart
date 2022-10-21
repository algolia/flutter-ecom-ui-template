import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class SizesGridView extends StatelessWidget {
  const SizesGridView(
      {Key? key, required this.sizes, this.selectedSizes = const {}, this.didSelectSize})
      : super(key: key);

  final List<String> sizes;
  final Set<String> selectedSizes;
  final Function(String)? didSelectSize;

  @override
  Widget build(BuildContext context) {
    final sizesCount = sizes.length;
    final rowsCount = sizesCount / 4 + (sizesCount % 4 == 0 ? 0 : 1);
    return SizedBox(
        height: rowsCount * 50,
        child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: 4,
            childAspectRatio: 4 / 2,
            padding: const EdgeInsets.only(top: 0),
            children: List.generate(sizesCount, (index) {
              String size = sizes[index];
              bool isSelected = selectedSizes.contains(size);
              if (isSelected) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: AppTheme.darkBlue),
                    onPressed: () => didSelectSize?.call(size),
                    child: Text(size));
              } else {
                return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: AppTheme.darkBlue,
                      side: const BorderSide(
                          width: 1.0,
                          color: AppTheme.darkBlue,
                          style: BorderStyle.solid),
                    ),
                    onPressed: () => didSelectSize?.call(size),
                    child: Text(size));
              }
            })));
  }
}
