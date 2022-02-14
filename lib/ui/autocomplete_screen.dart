import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/home_screen.dart';

class AutocompleteScreen extends StatefulWidget {
  const AutocompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutocompleteScreen> createState() => _AutocompleteScreenState();
}

class _AutocompleteScreenState extends State<AutocompleteScreen> {
  List<String> _history = ['jackets'];
  List<String> _suggestions = [
    'jackets',
    'shoes',
    'shoes black',
    'sweater',
    'moncler',
    'shoes',
    't-shirt'
  ];

  var searchTextController = TextEditingController();
  String _searchText = "";

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchTextController,
              autofocus: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black87, width: 1.0),
                  ),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search products, articles, faq, ..."),
            ),
          ),
          TextButton(
              onPressed: () => {Navigator.pop(context)}, child: Text("Cancel"))
        ],
      ),
    );
  }

  Widget _historyRow(String suggestion) {
    return Row(children: [
      Icon(Icons.replay),
      SizedBox(
        width: 10,
      ),
      Text(suggestion, style: TextStyle(fontSize: 20)),
      Spacer(),
      Icon(Icons.north_west),
    ]);
  }

  Widget _suggestionRow(String suggestion) {
    return Row(children: [
      Icon(Icons.search),
      SizedBox(
        width: 10,
      ),
      Text(suggestion, style: TextStyle(fontSize: 20)),
      Spacer(),
      Icon(Icons.north_west),
    ]);
  }

  Widget _customScrollView() {
    return Expanded(
        child: CustomScrollView(
      slivers: [
        SliverAppBar(
              title: Row(
                children: [Text("Your searches"), Spacer()],
              ),
              automaticallyImplyLeading: false),
        SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  String suggestion = _history[index];
                  return SizedBox(
                      height: 50,
                      child: InkWell(
                          onTap: () => {searchTextController.text = suggestion},
                          child: _historyRow(suggestion)));
                },
                childCount: _history.length, // 1000 list items
              ),
            )),
        SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            sliver: SliverAppBar(
                title: Row(children: [
                  Text(
                    "Popular searches",
                  ),
                  Spacer()
                ]),
                automaticallyImplyLeading: false)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              String suggestion = _suggestions[index];
              return SizedBox(
                  height: 50,
                  child: InkWell(
                      onTap: () => {searchTextController.text = suggestion},
                      child: _suggestionRow(suggestion)));
            },
            childCount: _suggestions.length, // 1000 list items
          )),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      _searchBar(),
      _customScrollView(),
    ])));
  }
}
