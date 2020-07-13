// CAMBIAR LAS RULES DE LA BASE DE DATOS !!! IMPORTANTE
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterchapp/src/pages/anglo/anglo_page.dart';
import 'package:waterchapp/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final int _primaryColor = 0xFFFFFFFF;
  final int _accentColor = 0xFF0000000;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/anglo': (context) => AngloPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.grey[600],
        accentColor: Colors.black,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 25, color: Color(_accentColor), fontWeight: FontWeight.w800),
          headline2: TextStyle(fontSize: 18),
          bodyText1: TextStyle(fontSize: 13.0),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF183863),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black)
          ),
        ),
        backgroundColor: Color(_primaryColor)
      ),
      home: HomePage(),
    );
  }
}