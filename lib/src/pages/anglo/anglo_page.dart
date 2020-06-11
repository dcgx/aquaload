import 'package:flutter/material.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/widgets/patent_widget.dart';

class AngloPage extends StatefulWidget {
  AngloPage({Key key}) : super(key: key);

  @override
  _AngloPageState createState() => _AngloPageState();
}

class _AngloPageState extends State<AngloPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador Anglo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage('assets/images/logo.png'), height: height(context)/10),
          SizedBox(height: height(context)/10,),
          Center(
            child: Text('Patentes', style: Theme.of(context).textTheme.subtitle,),
          ),
          Center(
            child: PatentWidget(),
          )
        ],
      ),
    );
  }
}
