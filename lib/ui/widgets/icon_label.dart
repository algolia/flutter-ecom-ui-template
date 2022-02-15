import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  const IconLabel({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(icon),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(text, style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }
}
