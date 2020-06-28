import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

double getHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
}
double getWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

getMonth(int monthNumber){
  switch(monthNumber){
    case 1:
      return 'Enero';
      break;
    case 2:
      return 'Febrero';
      break;
    case 3:
      return 'Marzo';
      break;
    case 4:
      return 'Abril';
      break;
    case 5:
      return 'Mayo';
      break;
    case 6:
      return 'Junio';
      break;
    case 7:
      return 'Julio';
      break;
    case 8:
      return 'Agosto';
      break;
    case 9:
      return 'Septiembre';
      break;
    case 10:
      return 'Octubre';
      break;
    case 11:
      return 'Noviembre';
      break;
    case 12:
      return 'Diciembre';
      break;
  }
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