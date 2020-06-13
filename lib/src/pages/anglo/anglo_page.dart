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
      appBar: _buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: getHeight(context)/10,),
          Image(image: AssetImage('assets/images/logo.png'), height: getHeight(context)/10),
          SizedBox(height: getHeight(context)/10,),
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

  _buildAppBar(){
    return AppBar(
      title: Text('Administrador Anglo'),
      backgroundColor: Colors.grey[500],
      leading: InkWell(
        child: Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
        onTap: (){
          Navigator.popAndPushNamed(context, '/home');
        },
      ),
    );
  }
}
