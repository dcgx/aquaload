import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waterchapp/src/functions/functions.dart';


class FormPage extends StatefulWidget {
  final String uid, patent, company;
  FormPage({Key key, this.uid, this.patent, this.company}) : super(key: key);

  @override
_FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _finalFlowController = TextEditingController();
  final _initialFlowController = TextEditingController();
  final _totalLoadedController = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final db = Firestore.instance;
  
  String formattedDate = DateFormat('dd-MM-yyyy - kk:mm').format(DateTime.now());
  File photoFile;
  String _url;
  double _totalLoaded;
  double _finalFlow;
  double _initialFlow;

  _openCamera(BuildContext context) async {
    var  picture= await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState((){
      photoFile=picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seleccione"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.camera_alt),
                      Text('Cámara'),
                    ],
                  ),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            ),
          ),
        );
      }
    );
  }  

  Widget validateImage(){
    if(photoFile==null){
      return Text("No se ha seleccionado una foto");
    }
    else{
      return Image.file(photoFile,width: getWidth(context)/2, height: getHeight(context)/2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40.0,),
                  Image(image: AssetImage('assets/images/logo.png',), height: getHeight(context)/14),
                  Text(widget.company),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.patent.substring(0,2)+"•"+widget.patent.substring(2,4)+'-'+widget.patent.substring(4,6), style: TextStyle(fontSize: 42, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Text(formattedDate.toString()),
                  TextFormField(
                    controller: _initialFlowController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Por favor rellene todos los campos';
                      }
                      return null;
                    },
                    onSaved: (value) => _initialFlow = double.parse(value),
                    decoration: InputDecoration(
                      labelText: 'Ingrese Datos Contador Inicial',
                      suffix: Text('m3', style: TextStyle(fontSize: 25.0),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      )
                    ),
                    style: TextStyle(fontSize: 20),
                    onChanged: (value){
                      _initialFlow = double.parse(value);
                      _totalLoaded = _finalFlow-_initialFlow;
                      _totalLoadedController.value = TextEditingValue(
                        text: _totalLoaded.toStringAsFixed(2)
                      );
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    controller: _finalFlowController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Por favor rellene todos los campos';
                      }
                      return null;
                    },
                    onSaved: (value) => _finalFlow = double.parse(value),
                    decoration: InputDecoration(
                      labelText: 'Ingrese Datos Contador Final',
                      suffix: Text('m3', style: TextStyle(fontSize: 25.0),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                    ),
                    style: TextStyle(fontSize: 20),
                    onChanged: (value){
                      _finalFlow = double.parse(value);
                      _totalLoaded = _finalFlow-_initialFlow;
                      _totalLoadedController.value = TextEditingValue(
                        text: _totalLoaded.toStringAsFixed(2)
                      );
                    },
                  ),                  
                  SizedBox(height: getHeight(context)/200,),
                  // Upload photo
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      validateImage(),
                      RaisedButton(
                        onPressed: () {
                          _showChoiceDialog(context);
                        },
                        child: Text("Agregar foto", style: TextStyle(color: Colors.white),),
                      )
                    ],
                  ),
                  
                  TextField(
                    enabled: false,
                    controller: _totalLoadedController,
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text('Salir', style: TextStyle(color: Colors.black),),
                            color: Colors.grey[300],
                            onPressed: (){
                              Navigator.popAndPushNamed(context, '/home');
                            },
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: Text('Borrar', style: TextStyle(color: Colors.black),),
                            color: Colors.grey[300],
                            onPressed: (){
                              _cleanForm();
                            },
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            child: Text('Enviar', style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              final form = _formKey.currentState;
                              if(form.validate() && photoFile!=null){
                                form.save();
                                saveToDataBase();
                                
                              }else{
                                showSnackBar(message: 'Por favor, agregar una fotografía', seconds: 1);
                              }
                            },
                          ),
                        ),

                      ],
                    )
                  )
                ],
              ),
            ),
          ),
      )
    );
  }

  void _cleanForm(){
    _initialFlowController.clear();
    _finalFlowController.clear();
    _totalLoadedController.clear();
    photoFile=null;
    setState(() {
      validateImage();
    });
  }

  void showSnackBar({String message, int seconds}){
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Color(0xFF183863),
      duration: Duration(seconds: seconds),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void saveToDataBase() async {
    if(_formKey.currentState.validate()){
      _totalLoaded = totalLoaded(_initialFlow, _finalFlow);
      _url = await uploadPhoto();
      _formKey.currentState.save();
      db.collection('data').document().setData(
        {
          'initialFlow': this._initialFlow,
          'finalFlow': this._finalFlow,
          'date': DateTime.now(),
          'totalLoaded': this._totalLoaded,
          'photoUrl': this._url,
          'loaded_by': this.widget.patent
        }
      );
      showSnackBar(message: 'Listo!. Datos correctamente guardados', seconds: 1);
      _cleanForm();
    }
  }

  Future<String> uploadPhoto() async {
    showSnackBar(message: 'Cargando fotografía...', seconds: 15);
    final StorageReference postPhotoRef = FirebaseStorage.instance.ref().child("photos");
    var timeKey = DateTime.now();
    final StorageUploadTask uploadTask = postPhotoRef.child(timeKey.toString() + ".jpg").putFile(photoFile);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    _url = imageUrl.toString();
    return _url;
  }
   
  double totalLoaded(double initialFlow, double finalFlow){
    double totalLoaded = finalFlow-initialFlow;
    return totalLoaded;
  }
}