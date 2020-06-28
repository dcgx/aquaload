import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseProvider{

  getAllData(){
    return Firestore.instance.collection('data').snapshots();
  }

  addToDataBase(data){
    Firestore.instance.collection('data').document().setData(data);
  }

  double totalMonth({List<DocumentSnapshot> documents, final month, String patent}){
    return patent!=null ? documents.where((doc) => doc['loaded_by'] == patent.toString())
                                   .where((doc) => DateFormat('M').format(DateTime.parse(doc['date'].toDate().toString())) == month.toString())
                                   .map((doc) => doc['totalLoaded'])
                                   .fold(0.0, (a, b) => a + b)
                        : 
                          documents.where((doc) => DateFormat('M').format(DateTime.parse(doc['date'].toDate().toString())) == month.toString())
                                   .map((doc) => doc['totalLoaded'])
                                   .fold(0.0, (a, b) => a + b);
  }

  List<double> totalPerDay({List<DocumentSnapshot> documents, final month, String patent}){
    return List.generate(31, (int index){
      if(patent!=null){
        return documents.where((doc) => doc['loaded_by'] == patent.toString())
                        .where((doc) => DateFormat('M').format(DateTime.parse(doc['date'].toDate().toString())) == month.toString())
                        .where((doc) => int.parse(DateFormat('d').format(DateTime.parse(doc['date'].toDate().toString()))) == (index + 1))
                        .map((doc) => doc['totalLoaded'])
                        .fold(0.0,(a , b) => a + b);
      } else{
        return documents.where((doc) => DateFormat('M').format(DateTime.parse(doc['date'].toDate().toString())) == month.toString())
                        .where((doc) => int.parse(DateFormat('d').format(DateTime.parse(doc['date'].toDate().toString()))) == (index + 1))
                        .map((doc) => doc['totalLoaded'])
                        .fold(0.0,(a , b) => a + b); 
      }
    });
  }

  getCredentials(String _password){
    return Firestore.instance.collection('users').where('password',isEqualTo: _password).getDocuments();
  }

  getUserByUid(String uid){
    return Firestore.instance.collection('users').where('uid',isEqualTo: uid).getDocuments();
  }


  List<int> counterPerDay({List<DocumentSnapshot> documents, final month, String patent}){
    return List.generate(31, (int index){
      if(patent!=null){
        return documents.where((doc) => doc['loaded_by'] == patent.toString())
                        .where((doc) => DateFormat('M').format(DateTime.parse(doc['date'].toDate().toString())) == month.toString())
                        .where((doc) => int.parse(DateFormat('d').format(DateTime.parse(doc['date'].toDate().toString()))) == (index + 1))
                        .fold(0,(counter , element) => counter + 1);
      } else{
        return documents.where((doc) => DateFormat('M').format(DateTime.parse(doc['date'].toDate().toString())) == month.toString())
                        .where((doc) => int.parse(DateFormat('d').format(DateTime.parse(doc['date'].toDate().toString()))) == (index + 1))
                        .map((doc) => doc['totalLoaded'])
                        .fold(0,(counter , element) => counter + 1);
      }
    });
  }

  getServerTimestamp(){
    return FieldValue.serverTimestamp();
  }
}