import 'package:flutter/material.dart';
import 'package:aquaload/src/widgets/helpers.dart';
import 'package:aquaload/src/pages/anglo/anglo_details.dart';
import 'package:aquaload/src/pages/sopraval/sopraval_page.dart';

class MonthWidget extends StatelessWidget {
  final String patent, company;
  MonthWidget({Key key, this.patent, this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            patent!=null ? MonthButton(month: 'Ene',patent: patent, company: company,) : MonthButton(month: 'Ene',),
            patent!=null ? MonthButton(month: 'May',patent: patent, company: company,) : MonthButton(month: 'May',),
            patent!=null ? MonthButton(month: 'Sep',patent: patent, company: company,) : MonthButton(month: 'Sep',),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            patent!=null ? MonthButton(month: 'Feb',patent: patent, company: company,) : MonthButton(month: 'Feb',),
            patent!=null ? MonthButton(month: 'Jun',patent: patent, company: company,) : MonthButton(month: 'Jun',),
            patent!=null ? MonthButton(month: 'Oct',patent: patent, company: company,) : MonthButton(month: 'Oct',),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            patent!=null ? MonthButton(month: 'Mar',patent: patent, company: company,) : MonthButton(month: 'Mar',),
            patent!=null ? MonthButton(month: 'Jul',patent: patent, company: company,) : MonthButton(month: 'Jul',),
            patent!=null ? MonthButton(month: 'Nov',patent: patent, company: company,) : MonthButton(month: 'Nov',),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            patent!=null ? MonthButton(month: 'Abr',patent: patent, company: company,) : MonthButton(month: 'Abr',),
            patent!=null ? MonthButton(month: 'Ago',patent: patent, company: company,) : MonthButton(month: 'Ago',),
            patent!=null ? MonthButton(month: 'Dic',patent: patent, company: company,) : MonthButton(month: 'Dic',),
          ],
        ),
      ],
    );
  }
}

class MonthButton extends StatelessWidget {  
  String month, patent, company;
  MonthButton({String month, String patent, String company}){
    this.month=month;
    this.patent=patent;
    this.company=company;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(context)/5,
      height: heigth(context)/14,
      child: OutlineButton(
        padding: EdgeInsets.all(15.0),
        child: Text(month, style: TextStyle(fontSize: 15, color: Colors.black, ),
        ),
        highlightColor: Colors.grey[300],
        onPressed:() {
          patent!=null ? _browse(context: context, month: month, patent: patent, company: company) : _browse(context: context, month: month,);
        }
      ),
    );
  }

  void _browse({BuildContext context, String month, String patent, String company}){
    switch(month){
      case 'Ene':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 1, patent: patent, company: company):SopravalPage(month: 1)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Feb':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 2, patent: patent, company: company):SopravalPage(month: 2)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Mar':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 3, patent: patent, company: company):SopravalPage(month: 3)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Abr':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 4, patent: patent, company: company):SopravalPage(month: 4)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'May':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 5, patent: patent, company: company):SopravalPage(month: 5)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Jun':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 6, patent: patent, company: company):SopravalPage(month: 6)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Jul':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 7, patent: patent, company: company):SopravalPage(month: 7)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Ago':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 8, patent: patent, company: company):SopravalPage(month: 8)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Sep':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 9, patent: patent, company: company):SopravalPage(month: 9)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Oct':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 10, patent: patent, company: company):SopravalPage(month: 10)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Nov':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 11, patent: patent, company: company):SopravalPage(month: 11)), 
                                    (Route<dynamic> route) => false);
        break;
      case 'Dic':
        Navigator.of(context)
                 .pushAndRemoveUntil(TransitionPageRoute(patent!=null ? AngloDetails(month: 12, patent: patent, company: company):SopravalPage(month: 12)), 
                                    (Route<dynamic> route) => false);
        break;
    }
  }
}

class TransitionPageRoute extends PageRouteBuilder {
  final Widget child;
  TransitionPageRoute(this.child)
    : super(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
      return child;
    }, transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
      return child;
    });
}