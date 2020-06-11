import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ObservationsPage extends StatefulWidget {
  ObservationsPage({Key key}) : super(key: key);

  @override
  _ObservationsPageState createState() => _ObservationsPageState();
}

class _ObservationsPageState extends State<ObservationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container()/*StreamBuilder(
         stream: Firestore.instance.collection('data').snapshots(),
         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
           if(!snapshot.hasData) {
             return Center(child: CircularProgressIndicator(),);
           }
           List<DocumentSnapshot> docs = snapshot.data.documents;
           return ListView.builder(
             itemCount: docs.length,
             itemBuilder: (context, index) {
               Map<String, dynamic> data = docs[index].data;
               return Column(
                 children: <Widget>[
                   Text(data['initialFlow'].toString()),
                   Text(data['finalFlow'].toString())
                 ],
               );
             }
           );
         }
       )**/
    );
  }
}