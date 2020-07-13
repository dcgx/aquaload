import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterchapp/src/widgets/helpers.dart';
import 'package:waterchapp/src/pages/anglo/anglo_page.dart';
import 'package:waterchapp/src/pages/camion/form_page.dart';
import 'package:waterchapp/src/pages/sopraval/sopraval_page.dart';
import 'package:waterchapp/src/providers/firebase_provider.dart';
import 'package:waterchapp/src/widgets/dialogs.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
  
  @override
  void initState() {
    password="";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Container(
        child: _buildScreen(),
      )
    );
  }

  Widget _buildAppBar(){
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
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildScreen(){
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
                  SizedBox(height: heigth(context)/15),
                  _buildLoginButton(),
                  SizedBox(height: heigth(context)/20,),
                  _buildPasswordRow(),
                ],
              ),
            ),
          ),
          _buildNumberPad(),
        ],
      ),
    );
  }

  Widget _buildLogo(){
    return Image(
      height: heigth(context)/10,
      image: AssetImage('assets/images/logo.png'),
    );
  }

  Widget _buildLoginButton(){
    return RaisedButton(
      child: Text(
        'Entrar',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      textColor: Colors.white,
      onPressed: (){
        Dialogs().checkConnectivity().then((internet){
          if(internet!=null && internet){
            getCredentials();
          } else{
            Dialogs().showNotConnectionDialog(context);
          }
        });
      }
    );
  }

  Future<void> getCredentials() async{
    Dialogs().showLoadingDialog(context);
    var provider = FirebaseProvider();
    await provider.getCredentials(password).then((QuerySnapshot docs){
      if(docs.documents.isNotEmpty){
        loggedIn=true;
        var user = docs.documents[0].data;
        checkRole(loggedIn, user);
      } else{
        loggedIn=false;
        setState(() {
          Navigator.pop(context);
          _showSnackBar(message: 'Contraseña incorrecta', icon: Icon(Icons.close));
        });
      }

    });
  }

  void checkRole(bool loggedIn, dynamic user){
    Dialogs().closeDialog(context);
    _clearPassInput();
    
    if(loggedIn){
      if(user['role']=='trucker'){
        loggedIn=false;
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => FormPage(uid: user['uid'], patent: user['patent'], company: user['company'],)
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

  void _clearPassInput(){
    password="";
    firstNumberController.clear();
    secondNumberController.clear();
    thirdNumberController.clear();
    fourthNumberController.clear();
    numberIndex=0;
  }

  void _showSnackBar({String message, Icon icon}){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            icon,
            Text(message, style: TextStyle(fontSize: 20),)
          ],
        ),
        duration: Duration(seconds: 1),
      )
    );
  }

  Widget _buildNumberPad(){
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
                    onPressed: () => _passIndexSetup("1")
                  ),
                  KeyboardNumber(
                    n: 2,
                    onPressed: () => _passIndexSetup("2")
                  ),
                  KeyboardNumber(
                    n: 3,
                    onPressed: () => _passIndexSetup("3")
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n: 4,
                    onPressed: () => _passIndexSetup("4")
                  ),
                  KeyboardNumber(
                    n: 5,
                    onPressed: () => _passIndexSetup("5")
                  ),
                  KeyboardNumber(
                    n: 6,
                    onPressed: () => _passIndexSetup("6")
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n: 7,
                    onPressed: () => _passIndexSetup("7")
                  ),
                  KeyboardNumber(
                    n: 8,
                    onPressed: () => _passIndexSetup("8")
                  ),
                  KeyboardNumber(
                    n: 9,
                    onPressed: () => _passIndexSetup("9")
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
                    onPressed: () => _passIndexSetup("0")
                  ),
                  Container(
                    width: width(context)/6,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0)
                      ),
                      onPressed: (){
                        _backspacePassButton();
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

  void _backspacePassButton(){
    if(numberIndex==0)
      numberIndex=0;
    else if (numberIndex == 4){
      _setPass(numberIndex, "");
      currentPassword[numberIndex-1] = "";
      numberIndex--;
    } else {
      _setPass(numberIndex, "");
      currentPassword[numberIndex-1] = "";
      numberIndex--;
    }
  }

  void _passIndexSetup(String text){
    if(numberIndex == 0){
      numberIndex=1;
    }
    else if(numberIndex < 4){
      numberIndex++;
    }
    _setPass(numberIndex, text);
    currentPassword[numberIndex-1] = text;
    String strNumber = "";
    currentPassword.forEach((e){
      strNumber += e;
    });
    password=strNumber;
  }

  void _setPass(int n, String text){
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

  Widget _buildPasswordRow(){
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
      width: width(context)/6,
      height: heigth(context)/10,
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
      width: width(context)/5,
      height: heigth(context)/12,
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