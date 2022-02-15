import 'package:flutter/material.dart';
import 'package:flutter_ecom_demo/ui/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_ecom_demo/ui/theme_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SWApp());
}

class SWApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primaryColor = ThemeColors.darkBlue;
    return MaterialApp(
      title: 'Spencer & Williams Fashion',
      theme: ThemeData(
          fontFamily: 'Inter',
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.white,
          buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: primaryColor,
            //toolbarTextStyle: TextStyle(color: primaryColor)
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: primaryColor))),
      home: const HomeScreen(),
    );
  }
}


