import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';

class BrandSelectorView extends StatelessWidget {
  const BrandSelectorView(
      {super.key, required this.facets, required this.onToggle});

  final Stream<List<SelectableFacet>> facets;
  final Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SelectableFacet>>(
        stream: facets,
        builder: (context, snapshot) {
          final facets = snapshot.data ?? [];
          return SliverFixedExtentList(
              itemExtent: 44,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final facet = facets[index];
                  return InkWell(
                    child: Row(children: [
                      Icon(
                        facet.isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(facet.item.value),
                      const Spacer(),
                      Text(facet.item.count > 0 ? '${facet.item.count}' : ''),
                    ]),
                    onTap: () => onToggle(facet.item.value),
                  );
                },
                childCount: facets.length,
              ));
        });
  }
}
