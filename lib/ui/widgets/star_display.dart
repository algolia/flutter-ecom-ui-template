import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  const StarDisplay({Key? key, this.value = 0, this.size = 8})
      : super(key: key);

  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          size: size,
        );
      }),
    );
  }
}
