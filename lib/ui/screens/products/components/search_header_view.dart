import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/screens/filters/filters_screen.dart';

import '../../../app_theme.dart';

class SearchHeaderView extends StatelessWidget {
  const SearchHeaderView(
      {Key? key,
      required this.query,
      this.resultsCount = 0,
      this.appliedFiltersCount = 0})
      : super(key: key);

  final String query;
  final int resultsCount;
  final int appliedFiltersCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
        Flexible(
            child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'Search results for: ',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.grey)),
            TextSpan(
                text: '"$query" ',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold)),
            TextSpan(
                text: '($resultsCount)',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.grey)),
          ]),
        )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: AppTheme.darkBlue),
            onPressed: () => {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const FiltersScreen();
                      })
                },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.filter_list),
                  Text("Filter & Sort"),
                ])),
      ],
    );
  }
}
