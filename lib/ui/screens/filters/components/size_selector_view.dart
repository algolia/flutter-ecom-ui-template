import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';

import '../../../app_theme.dart';

class SizeSelectorView extends StatelessWidget {
  const SizeSelectorView(
      {super.key, required this.facets, required this.onToggle});

  final Stream<List<SelectableFacet>> facets;
  final Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SelectableFacet>>(
        stream: facets,
        builder: (context, snapshot) {
          final facets = snapshot.data ?? [];
          return SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 65.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 2.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final facet = facets[index];
                  if (facet.isSelected) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: AppTheme.darkBlue),
                        onPressed: () => onToggle(facet.item.value),
                        child: Text(facet.item.value));
                  } else {
                    return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: AppTheme.darkBlue,
                          side: const BorderSide(
                              width: 1.0,
                              color: AppTheme.darkBlue,
                              style: BorderStyle.solid),
                        ),
                        onPressed: () => onToggle(facet.item.value),
                        child: Text(facet.item.value));
                  }
                },
                childCount: facets.length,
              ));
        });
  }
}
