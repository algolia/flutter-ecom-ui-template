import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/app_theme.dart';

class SearchHeaderView extends StatelessWidget {
  const SearchHeaderView({Key? key, required this.controller, this.onSubmitted}) : super(key: key);

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
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.darkBlue, width: 1.0)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.darkBlue, width: 1.0)),
              prefixIcon: const Icon(Icons.search, color: AppTheme.darkBlue),
              hintText: "Search products, articles, faq, ...",
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: controller.clear,
                      icon: const Icon(Icons.clear, color: AppTheme.darkBlue),
                    )
                  : null,
            ),
          ),
        ),
        TextButton(
            onPressed: () => {Navigator.pop(context)},
            child: const Text("Cancel"))
      ],
    );
  }
}
