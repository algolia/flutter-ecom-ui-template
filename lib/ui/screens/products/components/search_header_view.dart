import 'package:flutter/material.dart';

import '../../../app_theme.dart';

class SearchHeaderView extends StatelessWidget {
  const SearchHeaderView(
      {Key? key,
      required this.query,
      this.resultsCount = 0,
      this.appliedFiltersCount = 0,
      this.filtersButtonTapped})
      : super(key: key);

  final String query;
  final int resultsCount;
  final VoidCallback? filtersButtonTapped;
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
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration:
              BoxDecoration(color: AppTheme.darkBlue, border: Border.all()),
          child: TextButton(
              onPressed: filtersButtonTapped,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Filter & Sort",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (appliedFiltersCount != 0)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      ' $appliedFiltersCount ',
                      style: const TextStyle(color: AppTheme.darkBlue),
                    ),
                  ),
              ])),
        ),
      ],
    );
  }
}
