import 'package:flutter/material.dart';
import 'package:waterchapp/src/pages/camion/form_page.dart';
import 'package:waterchapp/src/pages/camion/observations_page.dart';

class TabsPage extends StatefulWidget{
  final String uid, patent, company;
  TabsPage({Key key, this.uid, this.patent, this.company}) : super  (key: key);
  @override
  State<StatefulWidget> createState() {
    return TabsPageState();
  }
}

class TabsPageState extends State<TabsPage>{
  int _currentIndex=0;
  var user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _browse(_currentIndex),
      bottomNavigationBar: _bottomNavigatorBar()
    );
  }
  
  _browse(int index){
    switch(index){
      case 1:
        return ObservationsPage();
        break;
      default: return FormPage(uid: widget.uid, patent: widget.patent, company: widget.company);
    }
  }

  _bottomNavigatorBar(){
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,  //Se puede cambiar por shifting
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Inicio')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Observaciones')
        ),
      ],
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
} 