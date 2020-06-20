import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'chatwindow.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController loginUserName = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  String loginOrSignUpText = "Login";
  String registerOrLoginText = "No Account? Register here";
  bool loginStatus;
  String message;

  validateUser() async {
    setState(() {
      loginStatus = false;
    });
    if (loginUserName.text.isNotEmpty && loginPassword.text.isNotEmpty) {
      var apiResponse = await http.read(
          "http://165.22.14.77:8080/Anwesh/ChatRoom/$loginOrSignUpText.jsp?UserName=${loginUserName.text}&Password=" +
              loginPassword.text);
      print(apiResponse);
      if (apiResponse.contains("uccess")) {
        if (loginOrSignUpText == "Login") {
          message = "Login success.";
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatWindow(username: loginUserName.text)),
          );
        } else {
          message = "Registered successfuly.";
          changeToLoginMode();
        }
      } else {
        if (apiResponse.contains("Failed")) {
          message = "Invalid username or password.";
        } else {
          message = apiResponse.trim();
        }
      }
    } else {
      message = "Username or Password can't be empty.";
    }

    Fluttertoast.showToast(
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Color(0xff002535),
        msg: message,
        gravity: ToastGravity.BOTTOM);
  }

  void changeToRegisterMode() {
    setState(() {
      loginOrSignUpText = "Register";
      registerOrLoginText = "Already had an Account? Login here.";
    });
  }

  void changeToLoginMode() {
    setState(() {
      loginOrSignUpText = "Login";
      registerOrLoginText = "No Account? Register here.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat Room",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 130, 20, 0),
                child: Text(
                  "Chat Room",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Pacific",
//                  fontStyle: FontStyle.italic,
                      fontSize: 50.0,
                      shadows: []),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(30.0)),
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(color: Colors.black, blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        loginOrSignUpText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
//                      fontFamily: "Acme",
                          fontStyle: FontStyle.italic,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: TextFormField(
                        controller: loginUserName,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Username",
                            prefixIcon: Icon(Icons.perm_identity)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextFormField(
                        controller: loginPassword,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            prefixIcon: Icon(Icons.vpn_key)),
                      ),
                    ),
                    RaisedButton(
                      textTheme: ButtonTextTheme.accent,
                      onPressed: () {
                        validateUser();
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
//                      side: BorderSide(color: Colors.red)
                      ),
                      child: Text(
                        loginOrSignUpText,
                        style: TextStyle(
                          shadows: [
                            Shadow(color: Colors.black),
                          ],
//                      fontStyle: FontStyle.italic,
                          color: Color(0xff002535),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                      child: FlatButton(
                        textTheme: ButtonTextTheme.accent,
                        onPressed: () {
                          setState(() {
                            if (loginOrSignUpText == 'Login') {
                              changeToRegisterMode();
                            } else {
                              changeToLoginMode();
                            }
                          });
                        },
                        color: Colors.white,
                        child: Text(
                          registerOrLoginText,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
