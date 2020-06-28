import 'package:flutter/material.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/pages/login/login_page.dart';

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
            child: _buildMainContent(),
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

  _buildMainContent(){
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(height: getHeight(context)/10,),
      _buildLogo(),
      SizedBox(height: getHeight(context)/10,),
      // ignore: deprecated_member_use
      Text('CARGA DE AGUA', style: TextStyle(color: Color(0xFF183863)  ,fontSize: Theme.of(context).textTheme.title.fontSize)),
      // ignore: deprecated_member_use
      Text('SOPRAVAL', style: TextStyle(color: Color(0xFF183863) ,fontSize: Theme.of(context).textTheme.title.fontSize)),
      SizedBox(height: getHeight(context)/4,),
      Text('Haga click en la pantalla', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, color: Colors.grey,)),
      ],
    );
  }

  _buildLogo(){
    return Image(
      image: AssetImage('assets/images/logo.png'), 
      height: getHeight(context)/10,
    );
  }
}