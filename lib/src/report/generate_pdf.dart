import 'dart:io';
import 'package:flutter/material.dart' as material;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:printing/printing.dart'; 
import 'package:aquaload/src/widgets/helpers.dart';
import 'package:aquaload/src/services/firestore_service.dart';
import 'package:aquaload/src/report/report_viewer_page.dart';

Future<File> generateSaveShowPdf({context, List<DocumentSnapshot> documents, var month, String patent, String company}) async {
  
  List<double> totalsPerDay = patent!=null ? FirebaseProvider().totalsPerDay(documents: documents, month: month, patent: patent) : FirebaseProvider().totalsPerDay(documents: documents, month: month);
  List<int> loadsPerDay = patent!=null ? FirebaseProvider().loadsPerDay(documents: documents, month: month, patent: patent) : FirebaseProvider().loadsPerDay(documents: documents, month: month);
  
  final pdf = Document();
  const logoProvider =  const material.AssetImage('assets/images/logo.png'); 
  final PdfImage logo = await pdfImageFromImageProvider(pdf: pdf.document, image: logoProvider);

  // Generate report (PDF)
  pdf.addPage (Page ( 
      pageFormat: PdfPageFormat.a3, 
      build: (Context context) { 
        return Column(
          children: [
            Row( 
              mainAxisAlignment: MainAxisAlignment.end, 
              children: [ 
                _buildLogo(image: logo),
              ] 
            ),
            SizedBox(height: 15),
            Table(
              children: [
                TableRow(
                  children: [
                    Container(
                      height: 30,
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
                          Text('Informe Agua Sopraval', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
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
                          Text(getMonth(month)+' 2020', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
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
                    _buildTableRowHeader(text: 'Día', width: 20),
                    _buildTableRowHeader(text: 'Patente', width: 24),
                    _buildTableRowHeader(text: 'Empresa', width: 26),
                    _buildTableRowHeader(text: 'Cargas', width: 18),
                    _buildTableRowHeader(text: 'Total (m3)', width: 25),
                    _buildTableRowHeader(text: 'Total acumulado (m3)', width: 40),
                  ]
                )
              ]
            )
            :
            Table(
              children: [
                TableRow(
                  children: [
                    _buildTableRowHeader(text: 'Día', width: 20),
                    _buildTableRowHeader(text: 'Cargas', width: 15),
                    _buildTableRowHeader(text: 'Total (m3)', width: 15),
                    _buildTableRowHeader(text: 'Total acumulado (m3)', width: 20),
                  ]
                )
              ]
            ),
            Table(
              //columnWidths: {1:FractionColumnWidth(.2)},
              children: patent!=null ? _loadDataListForAnglo(totalsPerDay: totalsPerDay, loadsPerDay: loadsPerDay, patent: patent, company: company, numberMonth: month) : _loadDataListForSopraval(totalsPerDay: totalsPerDay, loadsPerDay: loadsPerDay, numberMonth: month),
            ),
          ]
        );
      }
    )
  );

  // Save report (PDF)
  final output = await getTemporaryDirectory();
  final now = DateTime.now();
  final file = File("${output.path}/informe_agua_sopraval_${now.toString()}.pdf");
  await file.writeAsBytes(pdf.save());

  showReport(context, file);

  return file;
}

void showReport(context, File file){
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => ReportViewerPage(path: file.path,),
    ),
  );
}

void shareReport(String path){
  ShareExtend.share(path, "file");
}

dynamic _loadDataListForAnglo({List<double> totalsPerDay, List<int> loadsPerDay, String patent, String company, int numberMonth}){
  int day=0;
  double cumulativeTotal=0;
  double prevValue=0;
  
  return totalsPerDay.map((totalPerDay){
    prevValue = totalPerDay;
    cumulativeTotal = prevValue + cumulativeTotal;
    day++;
    return TableRow(
      children: [
        _buildTableRowItem(text: day.toString()+'-' + getMonth(numberMonth).substring(0,3).toLowerCase(), width: 20),
        _buildTableRowItem(text: patent.substring(0,4)+'-'+patent.substring(4,6), width: 24),
        _buildTableRowItem(text: company, width: 26),       
        _buildTableRowItem(text: loadsPerDay[day-1].toString(), width: 18),
        _buildTableRowItem(text: totalPerDay.toStringAsFixed(1), width: 25),
        _buildTableRowItem(text: cumulativeTotal.toStringAsFixed(1), width: 40),
      ]
    );
  }).toList();
}

dynamic _loadDataListForSopraval({List<double> totalsPerDay, List<int> loadsPerDay, int numberMonth}){
  int day=0;
  double cumulativeTotal=0;
  double prevValue=0;
  return totalsPerDay.map((totalPerDay){
    prevValue = totalPerDay;
    cumulativeTotal = prevValue + cumulativeTotal;
    day++;
    return TableRow(
      children: [
        _buildTableRowItem(text: day.toString()+'-' + getMonth(numberMonth).substring(0,3).toLowerCase(), width: 20),
        _buildTableRowItem(text: loadsPerDay[day-1].toString(), width: 15),
        _buildTableRowItem(text: totalPerDay.toStringAsFixed(1), width: 15),
        _buildTableRowItem(text: cumulativeTotal.toStringAsFixed(1), width: 20),
      ]
    );
  }).toList();
}

Widget _buildLogo({PdfImage image}){
  return Container( 
    width: 180, 
    child: Image(image) 
  );
}

Widget _buildTableRowHeader({String text, double width, double height}){
  return Container(
    width: width,
    height: 40.0,
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
        Text(text, style: TextStyle(fontSize: 19.0), textAlign: TextAlign.center)
      ],
    ),
  );
}

Widget _buildTableRowItem({String text, double width}){
  return Container(
    width: width,
    height: 25,
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
        Text(text, style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center)
      ],
    ),
  );
}