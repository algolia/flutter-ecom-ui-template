import 'package:flutter/material.dart';

import '../../../../model/search_metadata.dart';
import '../../../app_theme.dart';

class FiltersFooterView extends StatelessWidget {
  const FiltersFooterView(
      {super.key, required this.metadata, required this.onClear});

  final Stream<SearchMetadata> metadata;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
              onPressed: () => onClear(),
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
            child: StreamBuilder<SearchMetadata>(
          stream: metadata,
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
}
