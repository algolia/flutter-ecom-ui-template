import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

enum FiltersSection { none, sort, brand, size }

class _FiltersScreenState extends State<FiltersScreen> {
  final _indicesTitles = const <String, String>{
    'STAGING_native_ecom_demo_products': 'Most popular',
    'STAGING_native_ecom_demo_products_products_price_asc': 'Price Low to High',
    'STAGING_native_ecom_demo_products_products_price_desc':
        'Price High to Low',
  };

  FiltersSection activeSection = FiltersSection.none;

  bool _isActive(FiltersSection section) => section == activeSection;

  _toggle(FiltersSection section) =>
      activeSection = _isActive(section) ? FiltersSection.none : section;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom,
            left: 10,
            right: 10),
        child: Column(
          children: [
            _header(context),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _sortHeader(context),
                  if (_isActive(FiltersSection.sort)) _sortSelector(context),
                  _brandHeader(context),
                  if (_isActive(FiltersSection.brand)) _brandSelector(context),
                  _sizeHeader(context),
                  if (_isActive(FiltersSection.size)) _sizeSelector(context),
                ],
              ),
            ),
            const Divider(),
            _footer(context),
          ],
        ));
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Filter & Sort",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        IconButton(
            padding: const EdgeInsets.only(right: 0),
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _selectedFacetsCountContainer(
          Stream<List<SelectableFacet>> facetsStream) =>
      StreamBuilder<List<SelectableFacet>>(
          stream: facetsStream,
          builder: (context, snapshot) {
            final selectedFacetsCount =
                snapshot.data?.where((element) => element.isSelected).length ??
                    0;
            if (selectedFacetsCount > 0) {
              return Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  ' $selectedFacetsCount ',
                  style: const TextStyle(
                      color: AppTheme.darkBlue,
                      fontWeight: FontWeight.w400,
                      fontSize: 10),
                ),
              );
            } else {
              return Container();
            }
          });

  Widget _expandableRowHeader(
          BuildContext context,
          Widget title,
          FiltersSection section,
          Stream<List<SelectableFacet>>? facetsStream) =>
      SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          child: Row(
            children: [
              title,
              const Spacer(),
              if (facetsStream != null)
                _selectedFacetsCountContainer(facetsStream),
              Icon(_isActive(section) ? Icons.remove : Icons.add)
            ],
          ),
          onTap: () => setState(() => _toggle(section)),
        ),
      ));

  Widget _sortHeader(BuildContext context) => _expandableRowHeader(
      context,
      Column(
        children: [
          const Text('Sort',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          if (!_isActive(FiltersSection.sort))
            Text(
                '${_indicesTitles[context.read<ProductRepository>().selectedIndexName]}'),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      FiltersSection.sort,
      null);

  Widget _sortSelector(BuildContext context) => SliverFixedExtentList(
      itemExtent: 40,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final item = _indicesTitles.entries.toList()[index];
          final productRepository = context.read<ProductRepository>();
          return InkWell(
              onTap: () {
                setState(() {
                  productRepository.selectIndexName(item.key);
                  _toggle(FiltersSection.sort);
                });
              },
              child: Text(
                item.value,
                style: TextStyle(
                    fontWeight: item.key == productRepository.selectedIndexName
                        ? FontWeight.bold
                        : FontWeight.normal),
              ));
        },
        childCount: _indicesTitles.length,
      ));

  Widget _brandHeader(BuildContext context) => _expandableRowHeader(
      context,
      const Text('Brand',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      FiltersSection.brand,
      context.read<ProductRepository>().brandFacets);

  Widget _brandSelector(BuildContext context) => StreamBuilder<List<SelectableFacet>>(
      stream: context.read<ProductRepository>().brandFacets,
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
                    Text('${facet.item.count}'),
                  ]),
                  onTap: () => context
                      .read<ProductRepository>()
                      .toggleBrand(facet.item.value),
                );
              },
              childCount: facets.length,
            ));
      });

  Widget _sizeHeader(BuildContext context) => _expandableRowHeader(
      context,
      const Text('Size',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      FiltersSection.size,
      context.read<ProductRepository>().sizeFacets);

  Widget _sizeSelector(BuildContext context) => StreamBuilder<List<SelectableFacet>>(
      stream: context.read<ProductRepository>().sizeFacets,
      builder: (context, snapshot) {
        final productRepository = context.read<ProductRepository>();
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
                      style:
                          ElevatedButton.styleFrom(primary: AppTheme.darkBlue),
                      onPressed: () =>
                          productRepository.toggleSize(facet.item.value),
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
                      onPressed: () =>
                          productRepository.toggleSize(facet.item.value),
                      child: Text(facet.item.value));
                }
              },
              childCount: facets.length,
            ));
      });

  Widget _footer(BuildContext context) => Row(
        children: [
          Expanded(
            child: OutlinedButton(
                onPressed: () =>
                    context.read<ProductRepository>().clearFilters(),
                style: OutlinedButton.styleFrom(
                  primary: AppTheme.darkBlue,
                  side: const BorderSide(
                      width: 1.0,
                      color: AppTheme.darkBlue,
                      style: BorderStyle.solid),
                ),
                child: const Text(
                  "Clear Filters",
                  textAlign: TextAlign.center,
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: StreamBuilder<SearchResponse>(
            stream: context.read<ProductRepository>().searchResult,
            builder: (context, snapshot) {
              final String nbHits;
              if (snapshot.hasData) {
                nbHits = ' ${snapshot.data!.nbHits} ';
              } else {
                nbHits = '';
              }
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppTheme.darkBlue),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "See $nbHits Products",
                    textAlign: TextAlign.center,
                  ));
            },
          )),
        ],
      );
}
