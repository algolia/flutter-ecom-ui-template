import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/product_repository.dart';
import 'package:flutter_ecom_demo/ui/screens/product/components/sizes_grid_view.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final _indices = const <String, String>{
    'STAGING_native_ecom_demo_products': 'Default',
    'STAGING_native_ecom_demo_products_products_price_asc': 'Price asc',
    'STAGING_native_ecom_demo_products_products_price_desc': 'Price desc',
  };

  final _filters = const <String, String>{
    'product_type': 'Category',
    'brand': 'Brand',
    'available_sizes': 'Size',
  };

  String? _currentIndexName = 'STAGING_native_ecom_demo_products';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(context),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _sort(context),
                _brand(context),
                _size(context),
              ],
            ),
          ),
        ),
        _footer(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 15, right: 5, top: MediaQuery.of(context).padding.top),
      child: Row(
        children: [
          const Text(
            "Filter & Sort",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
    );
  }

  Widget _sort(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'Sort',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: Consumer<ProductRepository>(
          builder: (_, productRepository, __) => Text(
                '${_indices[productRepository.selectedIndexName]}',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              )),
      trailing: const Icon(Icons.add),
      children: [
        Consumer<ProductRepository>(
            builder: (_, productRepository, __) => ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _indices.length,
                  itemBuilder: (context, index) {
                    final entry = _indices.entries.toList()[index];
                    return ListTile(
                        leading: TextButton(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                            fontWeight:
                                productRepository.selectedIndexName == entry.key
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                      ),
                      onPressed: () => setState(() {
                        productRepository.selectIndexName(entry.key);
                      }),
                    ));
                  },
                )),
      ],
    );
  }

  Widget _brand(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'Brand',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.add),
      children: [
        Consumer<ProductRepository>(
            builder: (_, productRepository, __) =>
                StreamBuilder<List<SelectableFacet>>(
                    stream: productRepository.brandFacets,
                    builder: (context, snapshot) {
                      final facets = snapshot.data ?? [];
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final facet = facets[index];
                          return ListTile(
                            horizontalTitleGap: -5,
                            contentPadding: EdgeInsets.only(left: 0, right: 16),
                            leading: Checkbox(
                              value: facet.isSelected,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => AppTheme.darkBlue),
                              onChanged: (value) => productRepository
                                  .toggleBrand(facet.item.value),
                            ),
                            selectedColor: AppTheme.darkBlue,
                            title: Text(facet.item.value),
                            selected: facet.isSelected,
                            trailing: Text('${facet.item.count}'),
                            onTap: () =>
                                productRepository.toggleBrand(facet.item.value),
                          );
                        },
                        itemCount: facets.length,
                      );
                    })),
      ],
    );
  }

  Widget _size(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'Size',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.add),
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Consumer<ProductRepository>(
              builder: (_, productRepository, __) =>
                  StreamBuilder<List<SelectableFacet>>(
                      stream: productRepository.sizeFacets,
                      builder: (context, snapshot) {
                        final facets = snapshot.data ?? [];
                        return SizesGridView(
                          sizes: facets.map((e) => e.item.value).toList(),
                          selectedSizes: facets
                              .where((e) => e.isSelected)
                              .map((e) => e.item.value)
                              .toSet(),
                          didSelectSize: (size) =>
                              {productRepository.toggleSize(size)},
                        );
                      })),
        ),
      ],
    );
  }

  Widget _footer(BuildContext context) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Consumer<ProductRepository>(
        builder: (_, productRepository, __) => SafeArea(
            child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            OutlinedButton(
                onPressed: () => productRepository.clearFilters(),
                style: OutlinedButton.styleFrom(
                  primary: AppTheme.darkBlue,
                  side: const BorderSide(
                      width: 1.0,
                      color: AppTheme.darkBlue,
                      style: BorderStyle.solid),
                ),
                child: const Text("Clear Filters")),
            const Spacer(),
            StreamBuilder<SearchResponse>(
              stream: productRepository.searchResult,
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
                    child: Text("See $nbHits Products"));
              },
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        )),
      ));
}
