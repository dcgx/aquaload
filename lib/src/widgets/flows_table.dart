import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';

class FlowsTable extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final List<double> perDay;
  final double totalMonth;
  final String patent, company;
  final month;
  FlowsTable({Key key, this.documents, this.month, this.patent, this.company}) :     
            totalMonth = FirebaseProvider().totalMonth(documents: documents, month: month, patent: patent),                                        
            perDay = FirebaseProvider().totalPerDay(documents: documents, month: month, patent: patent),
            super(key: key);
  @override
  _FlowsTableState createState() => _FlowsTableState();
}

class _FlowsTableState extends State<FlowsTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DataTable(
          dataRowHeight: MediaQuery.of(context).size.height/34,
          columns: <DataColumn>[
            DataColumn(label: Text('Día'),),
            DataColumn(label: Text('m3'),),
            DataColumn(label: Padding(padding: const EdgeInsets.fromLTRB(1,0,1,0),)),
            DataColumn(label: Text('Día'),),
            DataColumn(label: Text('m3'),),
          ],
          rows: _buildRows()
        ),
        Text('Total por mes: ' + widget.totalMonth.toString())
      ],
    );
  }

  List<DataRow> _buildRows(){
    var listDataRow = new List<DataRow>();
    for(var i=1, j=16; i<=15 && j<=31; i++, j++){
      listDataRow.add(
        DataRow(
          cells: [
            DataCell(Text(i.toString())),
            DataCell(Text(widget.perDay[i-1].toString())),
            DataCell(Padding(padding: const EdgeInsets.fromLTRB(1,0,1,0),)),
            DataCell(Text(j.toString())),
            DataCell(Text(widget.perDay[j-1].toString())),
          ]
        )
      );
    }
    listDataRow.add(
      DataRow(
        cells: [
          DataCell(Text('')),
          DataCell(Text('')),
          DataCell(Padding(padding: const EdgeInsets.fromLTRB(1,0,1,0),)),
          DataCell(Text('31')),
          DataCell(Text(widget.perDay[30].toString())),
        ]
      )
    );
    return listDataRow;
  }
}