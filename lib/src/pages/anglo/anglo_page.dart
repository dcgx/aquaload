import 'package:flutter/material.dart';
import 'package:waterchapp/src/widgets/helpers.dart';
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
          SizedBox(height: heigth(context)/10,),
          Image(image: AssetImage('assets/images/logo.png'), height: heigth(context)/10),
          SizedBox(height: heigth(context)/10,),
          Center(
            child: Text('Patentes', style: Theme.of(context).textTheme.headline2,),
          ),
          Center(
            child: PatentWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(){
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
