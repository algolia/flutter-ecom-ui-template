import 'package:flutter/material.dart';

class SearchHeaderView extends StatelessWidget {
  const SearchHeaderView(
      {Key? key, required this.query, this.resultsCount = 0})
      : super(key: key);

  final String query;
  final int resultsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
        Text('Search results for: ',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.grey)),
        Text('"$query" ',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text('($resultsCount)',
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }
}
