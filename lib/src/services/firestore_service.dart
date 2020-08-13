import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class FirebaseProvider{

  dynamic getAllData(){
    return Firestore.instance.collection('data').snapshots();
  }

  dynamic getCredentials(String _password){
    return Firestore.instance.collection('users').where('password',isEqualTo: _password).getDocuments();
  }

  dynamic getUserByUid(String uid){
    return Firestore.instance.collection('users').where('uid',isEqualTo: uid).getDocuments();
  }
  
  dynamic getServerTimestamp(){
    return FieldValue.serverTimestamp();
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

  List<double> totalsPerDay({List<DocumentSnapshot> documents, final month, String patent}){
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


  List<int> loadsPerDay({List<DocumentSnapshot> documents, final month, String patent}){
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

  Future<String> uploadPhoto({String path, File file}) async{
    final StorageReference postPhotoRef = FirebaseStorage.instance.ref().child('photos');
    final StorageUploadTask uploadTask = postPhotoRef.child(path).putFile(file);
    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
      print('EVENT ${event.snapshot}');
    });
    var _photoUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    streamSubscription.cancel();
    String url = _photoUrl.toString();
    return url;
  }

  

  //   Future<String> uploadPhoto() async {
  //   final StorageReference postPhotoRef = FirebaseStorage.instance.ref().child("photos");
  //   var timeKey = DateTime.now();
  //   final StorageUploadTask uploadTask = postPhotoRef.child(widget.patent+timeKey.toString() + ".jpg").putFile(photoFile);
  //   final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
  //     print('EVENT ${event.snapshot}');
  //   });
  //   await uploadTask.onComplete;
  //   var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  //   streamSubscription.cancel();
  //   _url = imageUrl.toString();
  //   return _url;
  // }
}