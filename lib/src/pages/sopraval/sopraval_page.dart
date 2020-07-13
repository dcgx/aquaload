import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:waterchapp/src/widgets/helpers.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';
import 'package:waterchapp/src/report/generate_pdf.dart';
import 'package:waterchapp/src/widgets/flows_table.dart';

class SopravalPage extends StatefulWidget {
  final int month;
  const SopravalPage({Key key, this.month}) : super(key: key);

  @override
  _SopravalPageState createState() => _SopravalPageState();
}

class _SopravalPageState extends State<SopravalPage> {
  Stream<QuerySnapshot> _query;
  String monthValue = getMonth(int.parse(DateFormat('M').format(DateTime.now())));
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
        Image(image: AssetImage('assets/images/logo.png'), height: heigth(context)/10),
        Center(
          child: Text('Total m3 Transportado', style: TextStyle(fontSize: 20),),
        ),
        Divider(color: Colors.black,),
        // MonthWidget(),
        // Center(
        //   child: Text('Mes: ' + getMonth(widget.month), style: TextStyle(fontSize: 25),),
        // ),
        _buildDropdownButton(),
        Divider(color: Colors.black,),
        FlowsTable(month: getMonthNumber(monthValue), documents: snapshot.data.documents),
        SizedBox(height: heigth(context)/55),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: width(context)/2.5,
              child: RaisedButton(
                child: Text('Salir'),
                textColor: Colors.white,
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
              ),
            ),
            SizedBox(
              width: width(context)/2.5,
              child: RaisedButton(
                child: Text('Generar informe'),
                color: Colors.red[400],
                textColor: Colors.white,
                onPressed: (){
                  return generateSaveShowPdf(context: context, month: getMonthNumber(monthValue), documents: snapshot.data.documents);
                }
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDropdownButton(){
    return Center(
      child: DropdownButton<String>(
        value: monthValue,
        icon: Icon(Icons.date_range),
        iconSize: 25,
        style: TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        onChanged: (String newValue) {
          setState(() {
            monthValue = newValue;
          });
        },
        items: <String>['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(width:90, height:20, child: Text(value, style: TextStyle(fontSize: 16),),),
          );
        }).toList(),
      ),
    );
  }
}