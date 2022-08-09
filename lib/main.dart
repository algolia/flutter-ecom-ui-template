import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/app_theme.dart';
import 'package:flutter_ecom_demo/ui/screens/home/home_screen.dart';
import 'package:logging/logging.dart';

void main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SWApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
          '[${record.loggerName}/${record.level.name}]: ${record.time}: ${record.message}');
    }
  });
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
