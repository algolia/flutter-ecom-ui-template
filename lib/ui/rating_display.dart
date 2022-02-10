import 'package:flutter/material.dart';
import 'home.dart';

class RatingDisplay extends StatelessWidget {

  const RatingDisplay({Key? key, this.value = 0, required this.reviewsCount, this.fontSize = 8, this.iconSize = 8})
      : super(key: key);

  final int value;
  final int reviewsCount;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StarDisplay(value: value, size: iconSize,),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text('($reviewsCount)',
              style: TextStyle(fontSize: fontSize)),
        )
      ],
    );
  }

}