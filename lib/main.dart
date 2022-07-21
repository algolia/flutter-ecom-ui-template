import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/app_theme.dart';
import 'package:flutter_ecom_demo/ui/screens/home/home_screen.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _loggingConfig();
  runApp(const SWApp());
}

void _loggingConfig() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    //print(
    //    '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
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
