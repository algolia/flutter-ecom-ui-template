import 'package:flutter/material.dart';

class ExpandableHeaderView extends StatelessWidget {
  const ExpandableHeaderView({
    super.key,
    required this.title,
    required this.isActive,
    required this.onToggle,
  });

  final Widget title;
  final bool isActive;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        child: Row(
          children: [
            title,
            const Spacer(),
            Icon(isActive ? Icons.remove : Icons.add)
          ],
        ),
        onTap: () => onToggle(),
      ),
    ));
  }
}
