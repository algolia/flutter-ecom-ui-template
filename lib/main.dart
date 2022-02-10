import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/firebase_client.dart';
import 'package:flutter_ecom_demo/search_hit.dart';
import 'algolia_api_client.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algolia & Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final algoliaAPI = AlgoliaAPIClient("latency", "927c3fe76d4b52c5a2912973f35a3077", http.Client());
  List<SearchHit> _hitsList = [];
  TextEditingController _textFieldController = TextEditingController();
  String _searchText = "";
  final firebaseClient = FirebaseClient();

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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
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
                        final hit = _hitsList[index];
                        return Container(
                            height: 50,
                            padding: EdgeInsets.all(8),
                            child:
                            InkWell(
                                child: _buildRow(hit),
                                onTap: () {
                                  print("selected ${hit.name}");
                                  presentPage(context, hit);
                                }
                            )
                        );
                      }
                  )
              )
            ])
    );
  }

  void presentPage(BuildContext context, SearchHit hit) {
    firebaseClient.get(hit.objectID).then((product) =>
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  height: 200,
                  color: Colors.amber,
                  child: Center (
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text ("Product: ${product.brand} - ${product.name}"),
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close BottomSheet')
                            )
                          ]
                      )
                  ));
            })
    );
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
