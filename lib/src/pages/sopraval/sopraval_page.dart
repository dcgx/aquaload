import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';
import 'package:waterchapp/src/report/functions.dart';
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
        backgroundColor: Colors.grey[500],
        leading: InkWell(
          borderRadius: BorderRadius.circular(30.0),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onTap: (){
            Navigator.popAndPushNamed(context, '/home');
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _query,
        builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else{
            return _buildContent(snapshot);
          }
        }),
      )
    );
  }

  Widget _buildContent(AsyncSnapshot<QuerySnapshot> snapshot){
    return ListView(
      children: <Widget>[
        Image(image: AssetImage('assets/images/logo.png'), height: getHeight(context)/10),
        Center(
          // ignore: deprecated_member_use
          child: Text('Total m3 Transportado', style: Theme.of(context).textTheme.subtitle,),
        ),
        Divider(color: Colors.black,),
        MonthWidget(),
        Center(
          // ignore: deprecated_member_use
          child: Text('Mes: ' + getMonth(widget.month), style: Theme.of(context).textTheme.title,),
        ),
        Divider(color: Colors.black,),
        FlowsTable(month: widget.month, documents: snapshot.data.documents),
        SizedBox(height: getHeight(context)/55),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: getWidth(context)/2.5,
              child: RaisedButton(
                child: Text('Salir'),
                textColor: Colors.white,
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
              ),
            ),
            SizedBox(
              width: getWidth(context)/2.5,
              child: RaisedButton(
                child: Text('Generar informe'),
                color: Colors.red[400],
                textColor: Colors.white,
                onPressed: (){
                  return generateSaveShowReport(context: context, month: widget.month, documents: snapshot.data.documents);
                }
              ),
            ),
          ],
        )
      ],
    );
  }
}