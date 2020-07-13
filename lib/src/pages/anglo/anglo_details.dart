import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:waterchapp/src/widgets/helpers.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';
import 'package:waterchapp/src/report/generate_pdf.dart';
import 'package:waterchapp/src/widgets/flows_table.dart';

class AngloDetails extends StatefulWidget {
  final String patent, company;
  final int month;
  AngloDetails({Key key, this.month, this.patent, this.company}) : super(key: key);

  @override
  _AngloPageDetailsState createState() => _AngloPageDetailsState();
}

class _AngloPageDetailsState extends State<AngloDetails> {
  Stream<QuerySnapshot> _query;
  String monthValue = getMonth(int.parse(DateFormat('M').format(DateTime.now())));
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
          onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/anglo', (route) => false)
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
        _buildPatentTitle(),

        _buildDropdownButton(),
        Divider(color: Colors.black,),
        
        FlowsTable(month: getMonthNumber(monthValue), patent: widget.patent, company: widget.company, documents: snapshot.data.documents),
        SizedBox(height: heigth(context)/55),

        _buildFooterButtons(snapshot)
      ],
    );
  }

  Widget _buildPatentTitle(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          color: Colors.grey[200],
          child: Text(widget.patent.substring(0,2)+"•"+widget.patent.substring(2,4)+'-'+widget.patent.substring(4,6), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
        )
      ],
    );
  }
  
  Widget _buildHeader(){
    return Column(
      children: <Widget>[
        Image(image: AssetImage('assets/images/logo.png'), height: heigth(context)/10),
        Center(
          // ignore: deprecated_member_use
          child: Text('Total m3 Transportado', style: Theme.of(context).textTheme.subtitle,),
        ),
      ],
    );
  }

  Widget _buildFooterButtons(AsyncSnapshot<QuerySnapshot> snapshot){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: width(context)/3.5,
          child: RaisedButton(
            child: Text('Volver'),
            color: Colors.grey[300],
            textColor: Colors.black,
            onPressed: (){
              Navigator.of(context).popAndPushNamed('/anglo');
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
              return generateSaveShowPdf(context: context, month: getMonthNumber(monthValue), patent: widget.patent, company: widget.company, documents: snapshot.data.documents);
            }
          ),
        ),
        SizedBox(
          width: width(context)/3.5,
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