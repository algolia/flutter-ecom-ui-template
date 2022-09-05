import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/app_theme.dart';

class SearchHeaderView extends StatelessWidget {
  const SearchHeaderView({Key? key, required this.controller, this.onSubmitted})
      : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            autofocus: true,
            onSubmitted: onSubmitted,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search products, articles, faq, ..."),
          ),
        ),
        if (controller.text.isNotEmpty)
          IconButton(
              iconSize: 34,
              onPressed: controller.clear,
              icon: const Icon(Icons.clear),
              color: AppTheme.darkBlue),
        const SizedBox(width: 8)
      ],
    );
  }
}
