import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:aquaload/src/report/generate_pdf.dart';

class ReportViewerPage extends StatelessWidget {
  final String path;
  const ReportViewerPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Informe Agua Sopraval'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Compartir',
            onPressed: (){
              shareReport(path);
            },
          )
        ],
      ),
      path: path,
    );
  }
}