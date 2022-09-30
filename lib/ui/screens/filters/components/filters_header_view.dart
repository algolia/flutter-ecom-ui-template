import 'package:flutter/material.dart';

class FiltersHeaderView extends StatelessWidget {
  const FiltersHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Filter & Sort",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        IconButton(
            padding: const EdgeInsets.only(right: 0),
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close))
      ],
    );
  }
}
