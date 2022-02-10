import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/data/algolia_client.dart';
import 'package:flutter_ecom_demo/domain/product.dart';
import 'package:flutter_ecom_demo/domain/query.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final algoliaAPI = AlgoliaAPIClient("latency",
      "927c3fe76d4b52c5a2912973f35a3077", "STAGING_native_ecom_demo_products");
  List<Product> _hitsList = [];
  TextEditingController _textFieldController = TextEditingController();
  String _searchText = "";

  Future<void> _getSearchResult(String query) async {
    var response = await algoliaAPI.search(Query(query));
    var hitsList = (response['hits'] as List).map((json) {
      return Product.fromJson(json);
    }).toList();
    setState(() {
      _hitsList = hitsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Text('Algolia & Flutter'),
        ),
        body: Column(
            // padding: const EdgeInsets.all(8),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  height: 44,
                  child: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a search term',
                        prefixIcon:
                            Icon(Icons.search, color: Colors.deepPurple),
                        suffixIcon: _searchText.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _textFieldController.clear();
                                  });
                                },
                                icon: Icon(Icons.clear),
                              )
                            : null),
                  )),
              Expanded(
                  child: _hitsList.isEmpty
                      ? Center(child: Text('No results'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _hitsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 50,
                                padding: EdgeInsets.all(8),
                                child: Row(children: <Widget>[
                                  Container(
                                      width: 50,
                                      child: Image.network(
                                          '${_hitsList[index].image}')),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: Text('${_hitsList[index].name}'))
                                ]));
                          }))
            ]));
  }

  @override
  void initState() {
    super.initState();
    _textFieldController.addListener(() {
      if (_searchText != _textFieldController.text) {
        setState(() {
          _searchText = _textFieldController.text;
        });
        _getSearchResult(_searchText);
      }
    });
    _getSearchResult('');
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
