import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/screens/filters/components/size_selector_view.dart';
import 'package:flutter_ecom_demo/ui/screens/filters/components/sort_selector_view.dart';
import 'package:provider/provider.dart';

import '../../../data/search_repository.dart';
import '../../../model/sort_index.dart';
import 'components/brand_selector_view.dart';
import 'components/expandable_header_view.dart';
import 'components/filters_footer_view.dart';
import 'components/filters_header_view.dart';
import 'components/sort_title_view.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

enum FiltersSection { none, sort, brand, size }

class _FiltersScreenState extends State<FiltersScreen> {
  FiltersSection activeSection = FiltersSection.none;

  bool _isActive(FiltersSection section) => section == activeSection;

  @override
  Widget build(BuildContext context) {
    final searchRepository = context.read<SearchRepository>();
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom,
            left: 10,
            right: 10),
        child: Column(
          children: [
            const FiltersHeaderView(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _sortHeader(searchRepository.selectedIndex),
                  if (_isActive(FiltersSection.sort))
                    SortSelectorView(
                      sorts: searchRepository.selectedIndex,
                      onToggle: searchRepository.selectIndexName,
                    ),
                  _brandHeader(),
                  if (_isActive(FiltersSection.brand))
                    BrandSelectorView(
                      facets: searchRepository.brandFacets,
                      onToggle: searchRepository.toggleBrand,
                    ),
                  _sizeHeader(),
                  if (_isActive(FiltersSection.size))
                    SizeSelectorView(
                      facets: searchRepository.sizeFacets,
                      onToggle: searchRepository.toggleSize,
                    ),
                ],
              ),
            ),
            const Divider(),
            FiltersFooterView(
              metadata: searchRepository.searchMetadata,
              onClear: searchRepository.clearFilters,
            ),
          ],
        ));
  }

  Widget _sortHeader(Stream<SortIndex> sorts) {
    const section = FiltersSection.sort;
    final isActive = _isActive(section);
    return ExpandableHeaderView(
      title: SortTitleView(
        sorts: sorts,
        isActive: isActive,
      ),
      isActive: isActive,
      onToggle: () => _toggleSection(section),
    );
  }

  Widget _brandHeader() {
    const section = FiltersSection.brand;
    return ExpandableHeaderView(
      title: const Text('Brand',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      isActive: _isActive(section),
      onToggle: () => _toggleSection(section),
    );
  }

  Widget _sizeHeader() {
    const section = FiltersSection.size;
    return ExpandableHeaderView(
      title: const Text('Size',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      isActive: _isActive(section),
      onToggle: () => _toggleSection(section),
    );
  }

  _toggleSection(FiltersSection section) => setState(
      () => activeSection = _isActive(section) ? FiltersSection.none : section);
}
