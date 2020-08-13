import 'package:flutter/material.dart';
import 'package:aquaload/src/widgets/helpers.dart';
import 'package:aquaload/src/pages/anglo/anglo_details.dart';

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
            PatentButton(patent: 'LYES54', company: 'RC Ltda'),
            PatentButton(patent: 'HFST42', company: 'TRACAS',),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PatentButton(patent: 'KFSU15', company: 'RCT'),
            PatentButton(patent: 'LRBM45', company: 'RC Ltda.',),
          ],
        ),
      ],
    );
  }
}

class PatentButton extends StatelessWidget {  
  String _patent, _company;
  PatentButton({String patent, String company}){
    this._patent=patent;
    this._company=company;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(context)/2.5,
      child: OutlineButton(
        child: Text(_patent.substring(0,2)+"•"+_patent.substring(2,4)+'-'+_patent.substring(4,6), style: TextStyle(fontSize: 24, color: Colors.black, ),
        ),
        onPressed:() {
          _browse(_patent, _company, context);
        }
      ),
    );
  }

  void _browse(String patent, String company, BuildContext context){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) => AngloDetails(month: 1, patent: patent, company: company),
    ), (route) => false);
  }
}
