import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';
import 'package:waterchapp/src/report/functions.dart';
import 'package:waterchapp/src/widgets/flows_table.dart';
import 'package:waterchapp/src/widgets/month_widget.dart';

class AngloDetails extends StatefulWidget {
  final String patent, company;
  final int month;
  AngloDetails({Key key, this.month, this.patent, this.company}) : super(key: key);

  @override
  _AngloPageDetailsState createState() => _AngloPageDetailsState();
}

class _AngloPageDetailsState extends State<AngloDetails> {
  Stream<QuerySnapshot> _query;

  void initState(){
    super.initState(); 
    var provider = FirebaseProvider(); 
    _query = provider.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador Anglo'),
        backgroundColor: Colors.grey[500],
        leading: InkWell(
          borderRadius: BorderRadius.circular(30.0),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onTap: (){
            Navigator.of(context).pop();
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
            return _content(snapshot);
          }
        }),
      ),
    );
  }
    
  Widget _content(AsyncSnapshot<QuerySnapshot> snapshot){
    return ListView(
      children: <Widget>[
        _buildHeader(),
        Divider(color: Colors.black,),
        
        MonthWidget(patent: widget.patent, company: widget.company,),
        
        _buildMonthPatent(),
        Divider(color: Colors.black,),
        
        FlowsTable(month: widget.month, patent: widget.patent, company: widget.company, documents: snapshot.data.documents),
        SizedBox(height: getHeight(context)/55),

        _buildFooterButtons(snapshot)
      ],
    );
  }


  _buildMonthPatent(){
    return Row(
      children: <Widget>[
        SizedBox(width: getWidth(context)/13,),
        // ignore: deprecated_member_use
        Text('Mes: ' + getMonth(widget.month), style: Theme.of(context).textTheme.subtitle,),
        SizedBox(width: getWidth(context)/10,),
        // ignore: deprecated_member_use
        Text('Patente: ' + widget.patent.substring(0,4) +'-'+widget.patent.substring(4,6), style: Theme.of(context).textTheme.subtitle,)
      ],
    );
  }
  
  _buildHeader(){
    return Column(
      children: <Widget>[
        Image(image: AssetImage('assets/images/logo.png'), height: getHeight(context)/10),
        Center(
          // ignore: deprecated_member_use
          child: Text('Total m3 Transportado', style: Theme.of(context).textTheme.subtitle,),
        ),
      ],
    );
  }

  _buildFooterButtons(AsyncSnapshot<QuerySnapshot> snapshot){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: getWidth(context)/3.5,
          child: RaisedButton(
            child: Text('Volver'),
            color: Colors.grey[300],
            textColor: Colors.black,
            onPressed: (){
              Navigator.of(context).pop();
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
              return generateSaveShowReport(context: context, month: widget.month, patent: widget.patent, company: widget.company, documents: snapshot.data.documents);
            }
          ),
        ),
        SizedBox(
          width: getWidth(context)/3.5,
          child: RaisedButton(
            child: Text('Salir'),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            },
          ),
        )
      ],
    );
  }
}