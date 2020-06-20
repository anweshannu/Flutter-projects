import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ChatWindow extends StatefulWidget {
  final String username;
  ChatWindow({Key key, this.username}) : super(key: key);

  @override
  _ChatWindow createState() => _ChatWindow(username);
}

class _ChatWindow extends State<ChatWindow> {
  String username;
  _ChatWindow(String username) {
    this.username = username;
  }
  TextEditingController userMessage = TextEditingController();
  TextEditingController activeUsers = TextEditingController();
  TextEditingController chat = TextEditingController();
  bool stopTimer = false;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      var activeUsersApiResponse = await http.read(
          "http://165.22.14.77:8080/Anwesh/ChatRoom/GetActiveUsersData.jsp?UserName=$username");
      var chatApi = await http.read(
          "http://165.22.14.77:8080/Anwesh/ChatRoom/GetMessage.jsp?UserName=$username");
      setState(() {
        activeUsers.text = activeUsersApiResponse.replaceAll("&#8226;", "●").trim();
        chat.text = chatApi.trim();
      });
      print("\n\n\n\n Running\n\n\n\n");
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _sendMessage() async {
    var sendStatus = await http.read(
        "http://165.22.14.77:8080/Anwesh/ChatRoom/SendMessage.jsp?UserName=$username&Message=" +
            userMessage.text);
    if (sendStatus.contains("Sent")) {
      setState(() {
        userMessage.text = '';
      });
    } else {
      Fluttertoast.showToast(
          backgroundColor: Colors.white,
          textColor: Colors.brown,
          msg: "Message not sent",
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
//    _getActiveUsersAndMessages();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
//      resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Text(
                        "Chat Room",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Pacific",
//                  fontStyle: FontStyle.italic,
                            fontSize: 20.0,
                            shadows: []),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Active users",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Acme",
                              fontStyle: FontStyle.italic,
                              fontSize: 15.0,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              width: 270,
                              height: 50,
                              child: SingleChildScrollView(
                                  child: Text(
                                activeUsers.text,
                                style: TextStyle(color: Colors.green),
                              ))),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Chat window",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Acme",
                              fontStyle: FontStyle.italic,
                              fontSize: 15.0,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                              width: 270,
                              height: 450,
                              child: SingleChildScrollView(
                                  reverse: true,
                                  child: Text(
                                    chat.text,
                                    style: TextStyle(color: Colors.brown),
                                  ))),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black, blurRadius: 10),
                                ],
                              ),
                              child: SizedBox(
                                  width: 270,
                                  height: 50,
                                  child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 10, 0),
                                      child: TextField(
                                        controller: userMessage,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Type your message here"),
                                      )))),
                          Container(
                              margin: EdgeInsets.fromLTRB(5, 20, 0, 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black, blurRadius: 10),
                                ],
                              ),
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    splashColor: Colors.blue,
                                    onPressed: () {
                                      if (userMessage.text.isNotEmpty) {
                                        _sendMessage();
                                      }
                                    },
                                    icon:
                                        Icon(Icons.send, color: Colors.orange),
                                  ))),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(100.0)),
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 10),
                        ],
                      ),
                      child: SizedBox(
                        height: 30,
                        width: 100,
                        child: FlatButton(
                          splashColor: Colors.blue,
                          textTheme: ButtonTextTheme.accent,
                          onPressed: () {
                            Fluttertoast.showToast(
                                backgroundColor: Colors.white,
                                toastLength: Toast.LENGTH_SHORT,
                                textColor: Color(0xff002535),
                                msg: "Signed out successfully.",
                                gravity: ToastGravity.BOTTOM);
                            setState(() {

                              Navigator.pop(context);
                            });
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: Colors.white,
                          child: Text(
                            "Sign out",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
