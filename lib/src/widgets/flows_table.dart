import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';
import 'package:waterchapp/src/widgets/table_row_item.dart';

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
        Table(
          border: TableBorder.all(color: Colors.grey, width: 1.0),
          columnWidths: {0:FractionColumnWidth(.2), 2:FractionColumnWidth(.1), 3:FractionColumnWidth(.2)},
          children: [
            TableRowItem(perDay: widget.perDay, firColumnIndex: 1, secColumnIndex: 16),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 2, secColumnIndex: 18),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 3, secColumnIndex: 19),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 4, secColumnIndex: 20),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 5, secColumnIndex: 21),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 6, secColumnIndex: 22),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 7, secColumnIndex: 23),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 8, secColumnIndex: 24),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 9, secColumnIndex: 25),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 10, secColumnIndex: 26),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 11, secColumnIndex: 27),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 12, secColumnIndex: 28),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 13, secColumnIndex: 29),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 14, secColumnIndex: 30),
            TableRowItem(perDay: widget.perDay, firColumnIndex: 15, secColumnIndex: 31),
          ],
        ),
        Text('Total por mes: ' + widget.totalMonth.toString())
      ],
    );
  }
}