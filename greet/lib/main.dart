import 'dart:async';
import 'dart:ui';

import 'package:date_time_format/date_time_format.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController hourController = new TextEditingController();
  TextEditingController minuteController = new TextEditingController();
  TextEditingController secondController = new TextEditingController();
  TextEditingController ampmController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  DateTime dateTime;
  _getTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        dateTime = DateTime.now().toLocal();

        hourController.text = DateTimeFormat.format(dateTime, format: "h");
        minuteController.text = DateTimeFormat.format(dateTime, format: "i");
        print(minuteController.text);
        secondController.text = DateTimeFormat.format(dateTime, format: "s");
        ampmController.text = DateTimeFormat.format(dateTime, format: "A");
        dateController.text = DateTimeFormat.format(dateTime,
            format: AmericanDateFormats.abbrDayOfWeekAbbr);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getTime();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        backgroundColor: Colors.blue[400],
//          appBar: AppBar(title: Text('Greet Me'),),
        body: Container(
          color: Color(0xff145264),
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(),
                    child: Text("Greet Me \n",
                        style: TextStyle(
                            fontFamily: 'DancingScript',
                            color: Colors.white,
                            fontSize: 30)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextFormField(
                      controller: nameController,
                      decoration: new InputDecoration(
                        hintText: "Enter your name",
                        focusColor: Colors.red,
                        contentPadding: EdgeInsets.all(15),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (nameController.text.length > 0) {
                        Fluttertoast.showToast(
                            backgroundColor: Colors.white,
                            textColor: Color(0xff002535),
                            msg: "Hi " +
                                nameController.text +
                                " Good " +
                                getGreeting() +
                                "!",
                            gravity: ToastGravity.CENTER);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
//                      side: BorderSide(color: Colors.red)
                    ),
                    child: Text(
                      "Greet me",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xff002535),
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(65, 20, 0, 40),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                hourController.text +
                                    ":" +
                                    minuteController.text,
                                style: TextStyle(
                                    fontSize: 70.0, color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                                child: Text(
                                  ampmController.text,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 60, 0),
                            child: Text(
                              dateController.text,
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
//    throw UnimplementedError();
  }

  String getGreeting() {
    var hour = DateTime.now().toLocal().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

//  @override
//  State<StatefulWidget> createState() {
//    getTime();
//    throw UnimplementedError();
//  }
}
