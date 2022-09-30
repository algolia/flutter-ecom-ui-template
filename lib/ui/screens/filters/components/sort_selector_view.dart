import 'package:flutter/material.dart';

import '../../../../model/sorting.dart';

class SortSelectorView extends StatelessWidget {
  const SortSelectorView(
      {super.key, required this.sorts, required this.onToggle});

  final Stream<Sorting> sorts;
  final Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Sorting>(
        stream: sorts,
        builder: (context, snapshot) {
          final selectedIndex = snapshot.data;
          return SliverFixedExtentList(
              itemExtent: 40,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final item = Sorting.values[index];
                  return InkWell(
                      onTap: () => onToggle(item.indexName),
                      child: Text(
                        item.title,
                        style: TextStyle(
                            fontWeight: item == selectedIndex
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ));
                },
                childCount: Sorting.values.length,
              ));
        });
  }
}
