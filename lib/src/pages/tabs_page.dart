import 'package:waterchapp/src/pages/camion/form_page.dart';
import 'package:waterchapp/src/pages/observations_page.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TabsPageState();
  }
}

class TabsPageState extends State<TabsPage>{
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _browse(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
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
          )
        ],
        onTap: (index){
          setState(()=>_currentIndex = index);
        },
      ),
    );
  }
  
  Widget _browse(int index){
    switch(index){
      case 1:
        return ObservationsPage();
        break;
      default: return FormPage();
    }
  }

} 