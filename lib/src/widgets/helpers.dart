import 'package:flutter/material.dart';

double heigth(BuildContext context){
    return MediaQuery.of(context).size.height;
}

double width(BuildContext context){
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

getMonthNumber(String month){
  switch(month){
    case 'Enero':
      return 1;
      break;
    case 'Febrero':
      return 2;
      break;
    case 'Marzo':
      return 3;
      break;
    case 'Abril':
      return 4;
      break;
    case 'Mayo':
      return 5;
      break;
    case 'Junio':
      return 6;
      break;
    case 'Julio':
      return 7;
      break;
    case 'Agosto':
      return 8;
      break;
    case 'Septiembre':
      return 9;
      break;
    case 'Octubre':
      return 10;
      break;
    case 'Noviembre':
      return 11;
      break;
    case 'Diciembre':
      return 12;
      break;
  }
}



