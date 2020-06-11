// CAMBIAR LAS RULES DE LA BASE DE DATOS !!! IMPORTANTE
import 'package:flutter/material.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/pages/anglo/anglo_page.dart';
import 'package:waterchapp/src/pages/login/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final int _primaryColor = 0xFFFFFFFF;
  final int _accentColor = 0xFF0000000;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/anglo': (context) => AngloPage(),
      },
      theme: ThemeData(
        primaryColor: Color(_primaryColor),
        accentColor: Color(_accentColor),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 25.0, color: Color(_accentColor), fontWeight: FontWeight.w800),
          subtitle: TextStyle(fontSize: 18.0),
          body1: TextStyle(fontSize: 18.0),
          body2: TextStyle(fontSize: 13.0),
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
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body:GestureDetector(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: height(context)/10,),
                Image(image: AssetImage('assets/images/logo.png'), height: height(context)/10,),
                SizedBox(height: height(context)/10,),
                Text('CARGA DE AGUA', style: TextStyle(color: Color(0xFF183863)  ,fontSize: Theme.of(context).textTheme.title.fontSize)),
                Text('SOPRAVAL', style: TextStyle(color: Color(0xFF183863) ,fontSize: Theme.of(context).textTheme.title.fontSize)),
                SizedBox(height: height(context)/4,),
                Text('Haga click en la pantalla', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, color: Colors.grey,)),
              ],
            ),
          ),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => LoginPage()
          ));
        },
      ),
    );
  }
}
