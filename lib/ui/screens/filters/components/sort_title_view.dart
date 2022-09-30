import 'package:flutter/material.dart';

import '../../../../model/sorting.dart';

class SortTitleView extends StatelessWidget {
  const SortTitleView(
      {super.key, required this.sorts, required this.isActive});

  final Stream<Sorting> sorts;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sort',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        if (!isActive)
          StreamBuilder<Sorting>(
              stream: sorts,
              builder: (context, snapshot) =>
                  Text(snapshot.hasData ? snapshot.data!.title : '')),
      ],
    );
  }
}
