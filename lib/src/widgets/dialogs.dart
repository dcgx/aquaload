import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class Dialogs{
  Future<void> showLoadingDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height/8,
            color: Colors.grey[400],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width/20,),
                CircularProgressIndicator(),
                SizedBox(width: MediaQuery.of(context).size.width/20,),
                Text('Cargando...', style: TextStyle(fontSize: 18*MediaQuery.of(context).textScaleFactor)), 
              ]
            ),
          ),
        );
      }
    );
  }
  
  Future<void> showNotConnectionDialog(BuildContext context){
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context){
      return AlertDialog(
        title: Text('Error de conexión'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('No hay conexión a internet'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
  );
}

  void closeDialog(BuildContext context){
    Navigator.of(context).pop();
  }

  Future<bool> checkConnectivity() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}   