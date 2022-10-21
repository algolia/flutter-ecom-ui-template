import 'package:flutter/material.dart';

import '../../../../model/sort_index.dart';

class SortTitleView extends StatelessWidget {
  const SortTitleView(
      {super.key, required this.sorts, required this.isActive});

  final Stream<SortIndex> sorts;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sort',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        if (!isActive)
          StreamBuilder<SortIndex>(
              stream: sorts,
              builder: (context, snapshot) =>
                  Text(snapshot.hasData ? snapshot.data!.title : '')),
      ],
    );
  }
}
