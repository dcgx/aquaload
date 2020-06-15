import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waterchapp/src/functions/functions.dart';
import 'package:waterchapp/src/pages/anglo/anglo_page.dart';
import 'package:waterchapp/src/pages/sopraval/sopraval_page.dart';
import 'package:waterchapp/src/pages/tabs_page.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Container(
        child: OtpScreen(),
      )
    );
  }

  _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
        onTap: (){
          Navigator.popAndPushNamed(context, '/home');
        },
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  OtpScreen({Key key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<String> currentPassword = ["","","",""];
  TextEditingController firstNumberController = TextEditingController();
  TextEditingController secondNumberController = TextEditingController();
  TextEditingController thirdNumberController = TextEditingController();
  TextEditingController fourthNumberController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );

  int numberIndex = 0;
  String password;
  bool loggedIn=false;
  var user;
  
  @override
  void initState() {
    password="";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment(0,0.5),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildLogo(),
                  SizedBox(height: getHeight(context)/15),
                  _buildLoginButton(),
                  SizedBox(height: getHeight(context)/20,),
                  buildPasswordRow(),
                ],
              ),
            ),
          ),
          buildNumberPad(),
        ],
      ),
    );
  }

  _loadingDialog() { 
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
      return Dialog(
          child: Container(
            height: getHeight(context)/8,
            color: Colors.grey[400],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: getHeight(context)/30,),
                CircularProgressIndicator(),
                SizedBox(width: getWidth(context)/30,),
                Text('Cargando...', style: TextStyle(fontSize: 18*MediaQuery.of(context).textScaleFactor)), 
              ]
            ),
          )
        );
      }
    );
  }

  _buildLogo(){
    return Image(
      height: getHeight(context)/10,
      image: AssetImage('assets/images/logo.png'),
    );
  }

  _buildLoginButton(){
    return RaisedButton(
      child: Text(
        'Entrar',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      textColor: Colors.white,
      onPressed: (){
        getCredentials();
      }
    );
  }
  
  void getCredentials() async {
    _loadingDialog();
    await FirebaseProvider().getCredentials(password)
                      .then((QuerySnapshot docs){
                        if(docs.documents.isNotEmpty){
                          loggedIn=true;
                          user = docs.documents[0].data;
                          checkRole(loggedIn, user);
                          
                        } else{
                          loggedIn=false;
                          _showSnackBar(message: 'Contraseña incorrecta');
                        }
                      });
  }

  checkRole(bool loggedIn, dynamic user){
    if(loggedIn){
      if(user['role']=='trucker'){
        loggedIn=false;
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => TabsPage(uid: user['uid'], patent: user['patent'], company: user['company'],)
        ));
      } else if(user['role']=='adminAnglo'){
        loggedIn=false;
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => AngloPage()
        ));
      } else if(user['role']=='adminSopraval'){
        loggedIn=false;
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SopravalPage(month: 1)
        ));
      }
    }
  }


  _showSnackBar({String message}){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      )
    );
  }

  buildNumberPad(){
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n: 1,
                    onPressed: () {
                      passIndexSetup("1");
                    },
                  ),
                  KeyboardNumber(
                    n: 2,
                    onPressed: () {
                      passIndexSetup("2");
                    },
                  ),
                  KeyboardNumber(
                    n: 3,
                    onPressed: () {
                      passIndexSetup("3");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n: 4,
                    onPressed: () {
                      passIndexSetup("4");
                    },
                  ),
                  KeyboardNumber(
                    n: 5,
                    onPressed: () {
                      passIndexSetup("5");
                    },
                  ),
                  KeyboardNumber(
                    n: 6,
                    onPressed: () {
                      passIndexSetup("6");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n: 7,
                    onPressed: () {
                      passIndexSetup("7");
                    },
                  ),
                  KeyboardNumber(
                    n: 8,
                    onPressed: () {
                      passIndexSetup("8");
                    },
                  ),
                  KeyboardNumber(
                    n: 9,
                    onPressed: () {
                      passIndexSetup("9");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      color: Colors.white,
                      onPressed: null,
                      child: SizedBox(),
                    ),
                  ),
                  KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      passIndexSetup("0");
                    },
                  ),
                  Container(
                    width: getWidth(context)/6,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0)
                      ),
                      onPressed: (){
                        clearPass();
                      },
                      child: Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  clearPass(){
    if(numberIndex==0)
      numberIndex=0;
    else if (numberIndex == 4){
      setPass(numberIndex, "");
      currentPassword[numberIndex-1] = "";
      numberIndex--;
    } else {
      setPass(numberIndex, "");
      currentPassword[numberIndex-1] = "";
      numberIndex--;
    }
  }

  passIndexSetup(String text){
    if(numberIndex == 0){
      numberIndex=1;
    }
    else if(numberIndex < 4){
      numberIndex++;
    }
    setPass(numberIndex, text);
    currentPassword[numberIndex-1] = text;
    String strNumber = "";
    currentPassword.forEach((e){
      strNumber += e;
    });
    password=strNumber;
  }

  setPass(int n, String text){
    switch(n){
      case 1:
        firstNumberController.text = text;
        break;
      case 2:
        secondNumberController.text = text;
        break;
      case 3:
        thirdNumberController.text = text;
        break;
      case 4:
        fourthNumberController.text = text;
        break;
    }
  }

  buildPasswordRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PasswordNumber(
          outlineInputBorder:outlineInputBorder,
          textEditingController: firstNumberController
        ),
        PasswordNumber(
          outlineInputBorder:outlineInputBorder,
          textEditingController: secondNumberController
        ),
        PasswordNumber(
          outlineInputBorder:outlineInputBorder,
          textEditingController: thirdNumberController
        ),
        PasswordNumber(
          outlineInputBorder:outlineInputBorder,
          textEditingController: fourthNumberController
        ),
      ],
    );
  }
}

class PasswordNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;
  PasswordNumber({this.textEditingController, this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context)/6,
      height: getHeight(context)/10,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.white30,
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40.0,
          color: Colors.black,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  KeyboardNumber({this.n, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context)/5,
      height: getHeight(context)/12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        child: Text(
          "$n",
          textAlign: TextAlign.center, 
          style: TextStyle(
            fontSize: 38*MediaQuery.of(context).textScaleFactor,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}