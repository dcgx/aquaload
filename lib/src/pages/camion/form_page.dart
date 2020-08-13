import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aquaload/src/widgets/helpers.dart';
import 'package:aquaload/src/services/firestore_service.dart';
import 'package:aquaload/src/widgets/dialogs.dart';

class FormPage extends StatefulWidget {
  final patent, company;
  FormPage({Key key, this.patent, this.company}) : super(key: key);

  @override
_FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Provider
  var provider = FirebaseProvider();

  final _finalFlowController = TextEditingController();
  final _initialFlowController = TextEditingController();
  final _totalLoadedController = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  File photoFile;
  String _url;
  double _totalLoaded;
  double _finalFlow;
  double _initialFlow;
  String formattedDate = DateFormat('dd-MM-yyyy - kk:mm a').format(DateTime.now());

  void _openCamera(BuildContext context) async {
    var picture= await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 500);
    this.setState((){
      photoFile=picture;
    });
  }

  Widget validateImage(){
    if(photoFile==null){
      return Text("No se ha seleccionado una foto");
    }
    else{
      return Image.file(photoFile,width: width(context)/2, height: heigth(context)/2);
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
                  Divider(height: 40.0,),
                  // Header
                  Column(
                    children: <Widget>[
                      Image(image: AssetImage('assets/images/logo.png',), height: heigth(context)/14),
                      Text(widget.company),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.patent.substring(0,2)+"•"+widget.patent.substring(2,4)+'-'+widget.patent.substring(4,6), style: TextStyle(fontSize: 42, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Fecha formateada
                  Text(formattedDate),
                  Divider(height: 10,),
                  
                  // Text form fields
                  TextFormField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    controller: _initialFlowController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Complete todos los campos';
                      }
                      return null;
                    },
                    onSaved: (value) => _initialFlow = double.parse(value),
                    decoration: InputDecoration(
                      labelText: 'Ingrese Datos Contador Inicial',
                      labelStyle: TextStyle(fontSize: 20),
                      suffix: Text('m3', style: TextStyle(fontSize: 25.0),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      )
                    ),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    onChanged: (value){
                      _initialFlow = double.parse(value);
                      _totalLoaded = _finalFlow-_initialFlow;
                      _totalLoadedController.value = TextEditingValue(
                        text: _totalLoaded.toStringAsFixed(2)
                      );
                    },
                  ),
                  Divider(height: 20.0,),
                  
                  TextFormField(
                    controller: _finalFlowController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Complete todos los campos';
                      }
                      return null;
                    },
                    onSaved: (value) => _finalFlow = double.parse(value),
                    decoration: InputDecoration(
                      labelText: 'Ingrese Datos Contador Final',
                      labelStyle: TextStyle(fontSize: 20),
                      suffix: Text('m3', style: TextStyle(fontSize: 25.0),),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                    ),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    onChanged: (value){
                      _finalFlow = double.parse(value);
                      _totalLoaded = _finalFlow-_initialFlow;
                      _totalLoadedController.value = TextEditingValue(
                        text: _totalLoaded.toStringAsFixed(2)
                      );
                    },
                  ),
                  Divider(height: heigth(context)/200,),
                  
                  // Upload photo
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      validateImage(),
                      RaisedButton(
                        onPressed: () {
                          _openCamera(context);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.camera_alt, color: Colors.grey[200],),
                            Text("Agregar foto", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),
                          ],
                        )
                      )
                    ],
                  ),
                  Divider(height: 10),
				  
                  // Total loaded text field
                  Container(
                    height: 70,
                    child: TextFormField(
                      controller: _totalLoadedController,
                      textAlign: TextAlign.center,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Contador final',
                        hintStyle: TextStyle(fontSize: 18),
                        errorStyle: TextStyle(color: Colors.red),
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                        suffix: Text('m3', style: TextStyle(fontSize: 25.0,)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        ),
                      ),
                      validator: (value) {
                        if(double.parse(value)<0) {
                          return 'El contador no puede ser negativo';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),

                  // Form buttons
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text('Salir', style: TextStyle(color: Colors.black),),
                            color: Colors.grey[300],
                            onPressed: (){
                              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
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
                            child: Text('Guardar', style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              final form = _formKey.currentState;
                              Dialogs().checkConnectivity().then((internet){
                                if(internet!=null && internet){
                                  if(form.validate()){
                                    form.save();
                                    Dialogs().showLoadingDialog(context);
                                    saveToDataBase();
                                  }
                                  // if (photoFile==null){
                                  //   showSnackBar(message: 'Agregar una fotografía', seconds: 1, icon: Icon(Icons.info));
                                  // }
                                } else {
                                  Dialogs().showNotConnectionDialog(context);
                                }
                              });
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
    setState(() {
      _initialFlowController.clear();
      _finalFlowController.clear();
      _totalLoadedController.clear();
      photoFile=null;
      validateImage();
    });
  }

  void showSnackBar({String message, int seconds, Icon icon}){
    final snackbar = SnackBar(
      content: Row(
        children: <Widget>[
          icon,
          Text(message, style: TextStyle(fontSize: 15*MediaQuery.of(context).textScaleFactor)),
        ],
      ),
      backgroundColor: Color(0xFF183863),
      duration: Duration(seconds: seconds),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
  
  Future<void> saveToDataBase() async {
    if(_formKey.currentState.validate()){
      _totalLoaded = totalLoaded(_initialFlow, _finalFlow);
      if(photoFile!=null){
        _url = await _uploadPhotoAndGetUrl();
      } else{
        _url = null;
      }
      _formKey.currentState.save();
      
      Map<String, dynamic> data = 
      {
        'initialFlow': this._initialFlow,
        'finalFlow': this._finalFlow,
        'date': FirebaseProvider().getServerTimestamp(),
        'totalLoaded': this._totalLoaded,
        'photoUrl': this._url,
        'loaded_by': this.widget.patent
      };


      String path = widget.patent+'-'+DateFormat('ddMMyykkmm').format(DateTime.now());

      Firestore.instance.collection('data').document(path).setData(data).then((value){
        setState(() {
          _cleanForm();
          showSnackBar(message: 'Listo!, Datos correctamente guardados', seconds: 2, icon: Icon(Icons.check));
          Navigator.pop(context);
        });
      });      
    }
  }

  Future<String> _uploadPhotoAndGetUrl() async{
    var timeKey = DateTime.now().toString();
    var patent = widget.patent.toString();
    String path = patent+timeKey+".jpg";
    return provider.uploadPhoto(path: path, file: photoFile);
  }

  double totalLoaded(double initialFlow, double finalFlow){
    double totalLoaded = finalFlow-initialFlow;
    return totalLoaded;
  }
}