import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';
import 'package:waterchapp/src/widgets/flows_table.dart';
import 'package:waterchapp/src/widgets/month_widget.dart';

class SopravalPage extends StatefulWidget {
  final int month;
  const SopravalPage({Key key, this.month}) : super(key: key);

  @override
  _SopravalPageState createState() => _SopravalPageState();
}

class _SopravalPageState extends State<SopravalPage> {
  Stream<QuerySnapshot> _query;
  
  void initState(){
    super.initState();  
    var provider =  FirebaseProvider();
    _query = provider.getAllData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador Sopraval'),
      ),
      body: ListView(
        children: <Widget>[
          Image(image: AssetImage('assets/images/logo.png'), height: height(context)/10),
          Center(
            child: Text('Total m3 Transportado', style: Theme.of(context).textTheme.subtitle,),
          ),
          Divider(color: Colors.black,),
          MonthWidget(),
          Center(
            child: Text('Mes: ' + month(widget.month), style: Theme.of(context).textTheme.title,),
          ),
          Divider(color: Colors.black,),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return FlowsTable(month: widget.month, documents: snapshot.data.documents);
            }
          ),
          SizedBox(height: height(context)/55),
          RaisedButton(
            child: Text('Salir'),
            textColor: Colors.white,
            onPressed: (){
              Navigator.popAndPushNamed(context, '/home');
            },
          )
        ],
      ),
    );
  }
}