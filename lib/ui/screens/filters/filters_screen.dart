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

class _FiltersScreenState extends State<FiltersScreen> {
  final _indices = const <String, String>{
    'Default': 'STAGING_native_ecom_demo_products',
    'Price asc': 'STAGING_native_ecom_demo_products_products_price_asc',
    'Price desc': 'STAGING_native_ecom_demo_products_products_price_desc',
  };

  final _filters = const <String, String>{
    'Category': 'product_type',
    'Brand': 'brand',
    'Colours': 'color',
    'Size': 'available_sizes',
  };

  String? _currentIndexName = 'STAGING_native_ecom_demo_products';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 5),
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
        ),
        Expanded(
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
              ExpansionTile(
                title: const Text(
                  'Sort',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
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
                                  title: Text(entry.key),
                                  leading: Radio<String>(
                                    value: entry.value,
                                    groupValue: _currentIndexName,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _currentIndexName = entry.value;
                                      });
                                      productRepository
                                          .selectIndexName(entry.value);
                                    },
                                  ));
                            },
                          )),
                ],
              ),
              ExpansionTile(
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
                                    return CheckboxListTile(
                                        value: facet.isSelected,
                                        title: Text(
                                            '${facet.item.value} (${facet.item.count})'),
                                        onChanged: (value) {
                                          productRepository
                                              .toggleBrand(facet.item.value);
                                        });
                                  },
                                  itemCount: facets.length,
                                );
                              })),
                ],
              ),
            ])),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SafeArea(
              child: Consumer<ProductRepository>(
                  builder: (_, productRepository, __) => Row(
                        children: [
                          const Spacer(),
                          OutlinedButton(
                              onPressed: () => productRepository.clearFilters(),
                              style: OutlinedButton.styleFrom(
                                primary: AppTheme.darkBlue,
                                side: const BorderSide(
                                    width: 1.0,
                                    color: AppTheme.darkBlue,
                                    style: BorderStyle.solid),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Clear Filters"),
                                  ])),
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
                                  style: ElevatedButton.styleFrom(
                                      primary: AppTheme.darkBlue),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("See $nbHits Products"));
                            },
                          ),
                          const Spacer(),
                        ],
                      ))),
        ),
      ],
    );
  }
}
