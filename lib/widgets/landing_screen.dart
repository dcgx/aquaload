import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LandingScreen extends StatefulWidget {  
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File imageFile;

  _openGallery (BuildContext context) async {
    var  picture= await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState((){
      imageFile=picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var  picture= await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState((){
      imageFile=picture;
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
                        Icon(Icons.image),
                        Text('Galería'),
                      ],
                    ),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0),),
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
        });
  }
  //retorna  texto si no se ha seleccionado alguna imagen
  Widget _decideImageView(){
    if(imageFile==null){
      return Text("No se ha seleccionado una foto");
    }
    else{
      return  Image.file(imageFile,width: 400, height: 400);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _decideImageView(),
        RaisedButton(
          onPressed: () {
            _showChoiceDialog(context);
          },
          child: Text("Agregar foto"),
        )
      ],
    );
  }
}