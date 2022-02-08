import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class SearchHit {
  final String name;
  final String image;

  SearchHit(this.name, this.image);

  static SearchHit fromJson(Map<String, dynamic> json) {
    return SearchHit(json['name'], json['image_urls'][0]);
  }
}

class AlgoliaAPIClient extends http.BaseClient {

  final String appID;
  final String apiKey;
  final http.Client _inner;

  AlgoliaAPIClient(this.appID, this.apiKey, this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['content-type'] = "application/json";
    request.headers['X-Algolia-API-Key'] = apiKey;
    request.headers['X-Algolia-Application-Id'] = appID;
    print(request);
    print(request.headers);
    return _inner.send(request);
  }
  
  Future<Map<dynamic, dynamic>> search(String query) async {
    final request = http.Request("post", Uri.https('$appID-dsn.algolia.net', '1/indexes/STAGING_native_ecom_demo_products/query'));
    request.body = '{"params": "query=$query"}';
    final streamedResponse = await send(request);
    final response = await http.Response.fromStream(streamedResponse);
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algolia & Flutter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Algolia & Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final algoliaAPI = AlgoliaAPIClient("latency", "927c3fe76d4b52c5a2912973f35a3077", http.Client());
  List<SearchHit> _hitsList = [];
  TextEditingController _textFieldController = TextEditingController();
  String _searchText = "";

  Future<void> _getSearchResult(String query) async {
    var response = await algoliaAPI.search(query);
    print(response);
    var hitsList = (response['hits'] as List).map((json) {
      return SearchHit.fromJson(json);
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
                                child: 
                                InkWell (
                                  child: _buildRow(_hitsList[index]), 
                                  onTap: () { print("selected ${_hitsList[index].name}"); }
                                )
                            ); 
                          }
                        )
                )
            ]));
  }

Widget _buildRow(SearchHit hit) {
  return Row(children: <Widget>[
                                  Container(
                                      width: 50,
                                      child: Image.network(
                                          '${hit.image}')),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: Text('${hit.name}')
                                  )
                                ]);
}

  @override
  void initState() {
    super.initState();
    _textFieldController.addListener(() {
      if (_searchText != _textFieldController.text) {
        setState(() {
          _searchText = _textFieldController.text;
        });
        print(_searchText);
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
