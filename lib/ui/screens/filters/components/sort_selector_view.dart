import 'package:flutter/material.dart';

import '../../../../model/sort_index.dart';

class SortSelectorView extends StatelessWidget {
  const SortSelectorView(
      {super.key, required this.sorts, required this.onToggle});

  final Stream<SortIndex> sorts;
  final Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SortIndex>(
        stream: sorts,
        builder: (context, snapshot) {
          final selectedIndex = snapshot.data;
          return SliverFixedExtentList(
              itemExtent: 40,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final item = SortIndex.values[index];
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
                childCount: SortIndex.values.length,
              ));
        });
  }
}
