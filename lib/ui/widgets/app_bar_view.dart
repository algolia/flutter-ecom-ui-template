import 'package:flutter/material.dart';

/// S&W custom top app bar.
class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  const AppBarView({Key? key, this.bottom}) : super(key: key);

  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Image.asset('assets/images/og.png', height: 128),
      actions: const [
        IconLabelView(icon: Icons.pin_drop_outlined, text: 'STORES'),
        IconLabelView(icon: Icons.person_outline, text: 'ACCOUNTS'),
        IconLabelView(icon: Icons.shopping_bag_outlined, text: 'CART')
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class IconLabelView extends StatelessWidget {
  const IconLabelView({
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
