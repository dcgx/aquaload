import 'dart:io';
import 'package:flutter/material.dart' as material;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';
import 'package:waterchapp/src/report/report_viewer_page.dart';

Future<File> generateSaveShowReport({context, List<DocumentSnapshot> documents, var month, String patent, String company}) async {
  List<double> perDay = patent!=null ? FirebaseProvider().totalPerDay(documents: documents, month: month, patent: patent) : FirebaseProvider().totalPerDay(documents: documents, month: month);
  List<int> counterPerDay = patent!=null ? FirebaseProvider().counterPerDay(documents: documents, month: month, patent: patent) : FirebaseProvider().counterPerDay(documents: documents, month: month);
  final pdf = Document();
  // Generate report (PDF)
  pdf.addPage (Page ( 
      pageFormat: PdfPageFormat.a4, 
      build: (Context context) { 
        return Column(
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          left: true,
                          right: true,
                          bottom: true, 
                          width: 0.5,
                          color: PdfColors.black
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('Informe Agua Sopraval', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: BoxBorder(
                          top: true,
                          left: true,
                          right: true,
                          bottom: true, 
                          width: 0.5,
                          color: PdfColors.black
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(getMonth(month)+' 2020', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                        ],
                      ),
                    ),   
                  ]
                ),
              ]
            ),
            patent != null 
            ? 
            Table(
              children: [
                TableRow(
                  children: [
                    _buildTableRowHeader(text: 'Día', width: 20, height: 45.0),
                    _buildTableRowHeader(text: 'Patente', width: 24, height: 45.0),
                    _buildTableRowHeader(text: 'Empresa', width: 26, height: 45.0),
                    _buildTableRowHeader(text: 'Cargas', width: 18, height: 45.0),
                    _buildTableRowHeader(text: 'Total (m3)', width: 25, height: 45.0),
                    _buildTableRowHeader(text: 'Total acumulado (m3)', width: 40, height: 45.0),
                  ]
                )
              ]
            )
            :
            Table(
              children: [
                TableRow(
                  children: [
                    _buildTableRowHeader(text: 'Día', width: 20, height: 45.0),
                    _buildTableRowHeader(text: 'Cargas', width: 15, height: 45.0),
                    _buildTableRowHeader(text: 'Total (m3)', width: 15, height: 45.0),
                    _buildTableRowHeader(text: 'Total acumulado (m3)', width: 20, height: 45.0),
                  ]
                )
              ]
            ),
            Table(
              //columnWidths: {1:FractionColumnWidth(.2)},
              children: patent!=null ? _loadDataListForAnglo(perDay: perDay, counterPerDay: counterPerDay, patent: patent, company: company, numberMonth: month) : _loadDataListForSopraval(perDay: perDay, counterPerDay: counterPerDay, numberMonth: month),
            ),
          ]
        );
      }
    )
  );

  // Save report (PDF)
  final output = await getTemporaryDirectory();
  final now = DateTime.now();
  final file = File("${output.path}/informe_agua_sopraval_${now}.pdf");
  print(pdf);
  await file.writeAsBytes(pdf.save());

  await showReport(context, file);

  return file;
}

showReport(context, File file){
  // Show report (PDF)
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => ReportViewerPage(path: file.path,),
    ),
  );
}

shareReport(String path){
  ShareExtend.share(path, "file");
}

_loadDataListForAnglo({List<double> perDay, List<int> counterPerDay, String patent, String company, int numberMonth}){
  int counter=0;
  double culumativeTotal=0;
  double prevValue=0;
  
  return perDay.map((day){
    prevValue = day;
    culumativeTotal = prevValue + culumativeTotal;
    counter++;
    return TableRow(
      children: [
        _buildTableRowItem(text: counter.toString()+'-' + getMonth(numberMonth).substring(0,3).toLowerCase(), width: 20),
        _buildTableRowItem(text: patent.substring(0,4)+'-'+patent.substring(4,6), width: 24),
        _buildTableRowItem(text: company, width: 26),       
        _buildTableRowItem(text: counterPerDay[counter-1].toString(), width: 18),
        _buildTableRowItem(text: day.toString(), width: 25),
        _buildTableRowItem(text: culumativeTotal.toString(), width: 40),
      ]
    );
  }).toList();
}


_loadDataListForSopraval({List<double> perDay, List<int> counterPerDay, int numberMonth}){
  int counter=0;
  double culumativeTotal=0;
  double prevValue=0;
  return perDay.map((day){
    prevValue = day;
    culumativeTotal = prevValue + culumativeTotal;
    counter++;
    return TableRow(
      children: [
        _buildTableRowItem(text: counter.toString()+'-' + getMonth(numberMonth).substring(0,3).toLowerCase(), width: 20),
        _buildTableRowItem(text: counterPerDay[counter-1].toString(), width: 15),
        _buildTableRowItem(text: day.toString(), width: 15),
        _buildTableRowItem(text: culumativeTotal.toString(), width: 20),
      ]
    );
  }).toList();
}

_buildTableRowHeader({String text, double width, double height}){
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      border: BoxBorder(
        top: true,
        left: true,
        right: true,
        bottom: true, 
        width: 0.5,
        color: PdfColors.black
      ),
    ),
    child: Column(
      children: <Widget>[
        Text(text, style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center)
      ],
    ),
  );
}

_buildTableRowItem({String text, double width}){
  return Container(
    width: width,
    decoration: BoxDecoration(
      border: BoxBorder(
        top: true,
        left: true,
        right: true,
        bottom: true, 
        width: 0.5,
        color: PdfColors.black
      ),
    ),
    child: Column(
      children: <Widget>[
        Text(text, style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center)
      ],
    ),
  );
}