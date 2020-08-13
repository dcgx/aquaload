import 'package:flutter/material.dart';
import 'package:aquaload/src/widgets/helpers.dart';
import 'package:aquaload/src/pages/login/login_page.dart';

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
            child: _buildContent(),
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

  _buildContent(){
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(height: heigth(context)/10,),
      _buildLogo(),
      SizedBox(height: heigth(context)/10,),
      Text('CARGA DE AGUA', style: TextStyle(color: Color(0xFF183863), fontSize: Theme.of(context).textTheme.headline1.fontSize)),
      Text('SOPRAVAL', style: TextStyle(color: Color(0xFF183863), fontSize: Theme.of(context).textTheme.headline1.fontSize)),
      SizedBox(height: heigth(context)/4,),
      Text('Haga click en la pantalla', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, color: Colors.grey,)),
      Divider(height: 60,),
      FlatButton(
        child: Text('Instructivo de la APP'),
        onPressed: (){},
      ),
    ]);
  }

  _buildLogo(){
    return Image(
      image: AssetImage('assets/images/logo.png'), 
      height: heigth(context)/10,
    );
  }
}