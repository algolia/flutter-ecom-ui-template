import 'package:flutter/material.dart';

import '../../../app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.title,
    this.onMorePressed,
  }) : super(key: key);

  final String title;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.subtitle2),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See More',
            style: TextStyle(color: AppTheme.nebula),
          ),
        )
      ],
    );
  }
}
