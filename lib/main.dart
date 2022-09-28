import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'data/product_repository.dart';
import 'data/search_repository.dart';
import 'data/suggestion_repository.dart';
import 'ui/app_theme.dart';
import 'ui/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupLogging();
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => ProductRepository()),
      Provider(create: (context) => SuggestionRepository()),
      Provider(create: (context) => SearchRepository()),
    ],
    child: const SWApp(),
  ));
}

void _setupLogging() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
}

/// S&W Fashion App entry point.
class SWApp extends StatelessWidget {
  const SWApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spencer & Williams Fashion',
      theme: AppTheme.buildLightTheme(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
