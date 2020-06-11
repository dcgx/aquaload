import 'package:flutter/material.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/pages/anglo/anglo_details.dart';

class PatentWidget extends StatelessWidget {
  const PatentWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TruckButton(patent: 'LYES54', company: 'RC Ltda'),
            TruckButton(patent: 'HFST42', company: 'TRACAS',),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TruckButton(patent: 'KFSU15', company: 'RCT'),
            TruckButton(patent: 'LRBM45', company: 'RC Ltda.',),
          ],
        ),
      ],
    );
  }
}

class TruckButton extends StatelessWidget {  
  String _patent, _company;
  TruckButton({String patent, String company}){
    this._patent=patent;
    this._company=company;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(context)/2.5,
      child: OutlineButton(
        child: Text(_patent.substring(0,4) +'-'+_patent.substring(4,6), style: TextStyle(fontSize: 24, color: Colors.black, ),
        ),
        onPressed:() {
          _browse(_patent, _company, context);
        }
      ),
    );
  }

  Widget _browse(String patent, String company, BuildContext context){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AngloDetails(month: 1, patent: patent, company: company),
    ));
  }
}
