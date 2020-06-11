import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/pages/anglo/anglo_page.dart';
import 'package:waterchapp/src/pages/instructive/instructive_page.dart';
import 'package:waterchapp/src/pages/sopraval/sopraval_page.dart';
import 'package:waterchapp/src/pages/tabs_page.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loggedIn = false;
  final _passwordController =  TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _password;
  var user;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(60),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(image: AssetImage('assets/images/logo.png'), height: height(context)/10,),
                          SizedBox(height: height(context)/16,),
                          Text('CARGA DE AGUA', style: TextStyle(color: Color(0xFF183863)  ,fontSize: Theme.of(context).textTheme.title.fontSize)),
                          Text('SOPRAVAL', style: TextStyle(color: Color(0xFF183863) ,fontSize: Theme.of(context).textTheme.title.fontSize)),
                        ],
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if(value.isEmpty || value.length > 4 || value.length < 4) {
                          return 'Ingrese contraseña (4 dígitos)';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value,
                    decoration: InputDecoration(labelText: 'Contraseña (XXXX)', ),
                    style: TextStyle(fontSize: 25.0),
                  ),

                  RaisedButton(
                    child: Text('INGRESAR'),
                    textColor: Colors.white,
                    onPressed: (){
                      if(formKey.currentState.validate()){
                        formKey.currentState.save();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Procesando datos..'), duration: Duration(seconds: 1),));
                        FirebaseProvider().getCredentials(_password).then((QuerySnapshot docs){
                          if(docs.documents.isNotEmpty){
                            loggedIn=true;
                            user = docs.documents[0].data;
                            checkRole(loggedIn);

                          } else{
                            loggedIn=false;
                            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Contraseña incorrecta'), duration: Duration(seconds: 1),));
                          }
                        });
                      }
                    },
                  ),

                  RaisedButton(
                    child: Text('INSTRUCTIVO DE USO APP'),
                    color: Colors.grey[300],
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => InstructivePage()
                      ));
                    },
                  )
                ],
              ),
            ),
          ),
      )
    );
  }
  checkRole(bool loggedIn){
    if(loggedIn){
      if(user['role']=='trucker'){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => TabsPage(uid: user['uid'], patent: user['patent'], company: user['company'],)
        ));
      } else if(user['role']=='adminAnglo'){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => AngloPage()
        ));
      } else if(user['role']=='adminSopraval'){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SopravalPage(month: 1)
        ));
      }
    }
  }
}