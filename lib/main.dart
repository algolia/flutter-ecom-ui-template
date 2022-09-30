import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'data/product_repository.dart';
import 'ui/app_theme.dart';
import 'ui/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupLogging();
  runApp(const SWApp());
}

void _setupLogging() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
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
      home: Provider<ProductRepository>(
        create: (_) => ProductRepository(),
        dispose: (_, value) => value.dispose(),
        child: const HomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
