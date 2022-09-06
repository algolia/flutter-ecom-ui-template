import 'package:flutter/material.dart';

import '../../app_theme.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final _filters = <String, List<String>>{
    'Sort': ['Price increasing', 'Most Popular', 'Alphabetically'],
    'Category': ['Shoes', 'Clothes'],
    'Brand': ['Samsung', 'Apple', 'Sony'],
    'Colours': ['Red', 'Green', 'Blue'],
    'Size': ['S', 'M', 'L'],
    'Materials': ['Leather', 'Cotton', 'Viscose'],
  };

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
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final filter = _filters.entries.toList()[index];
              final name = filter.key;
              final values = filter.value;
              return ExpansionTile(
                title: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.add),
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(values[index]),
                      );
                    },
                    itemCount: values.length,
                  )
                ],
              );
            },
            itemCount: _filters.length,
          ),
        ),
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
              child: Row(
            children: [
              const Spacer(),
              OutlinedButton(
                  onPressed: () => {},
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppTheme.darkBlue),
                  onPressed: () => {},
                  child: const Text("See 37 Products")),
              const Spacer(),
            ],
          )),
        ),
      ],
    );
  }
}
