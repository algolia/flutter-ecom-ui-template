import 'package:flutter/material.dart';

class NoResultsView extends StatelessWidget {
  const NoResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Try the following:",
              style: Theme.of(context).textTheme.bodyText1),
          const SizedBox(height: 4),
          Text("• Check your spelling",
              style: Theme.of(context).textTheme.bodyText2),
          Text("• Searching again using more general terms",
              style: Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }
}
