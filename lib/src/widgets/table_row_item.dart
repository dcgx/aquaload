import 'package:flutter/material.dart';
TableRowItem ({List<double> perDay, int firColumnIndex, int secColumnIndex}) {
  return TableRow(
    children: [
      Column(
        children: <Widget>[
          Text(firColumnIndex.toString(), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
        ],
      ),
      Column(
        children: <Widget>[
          Text(perDay[firColumnIndex-1].toStringAsFixed(2), style: TextStyle(fontSize: 15.0), textAlign: TextAlign.right)
        ],
      ),
      Column(
        children: <Widget>[
          SizedBox()
        ],
      ),
      Column(
        children: <Widget>[
          Text(secColumnIndex.toString(), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
        ],
      ),
      Column(
        children: <Widget>[
          Text(perDay[secColumnIndex-1].toStringAsFixed(2), style: TextStyle(fontSize: 15.0), textAlign: TextAlign.right)
        ],
      )
    ]
  );
}