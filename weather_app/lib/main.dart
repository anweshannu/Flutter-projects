import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: "Weather App",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool visibleStatus = false;
  TextEditingController locationController = new TextEditingController();
  TextEditingController tempController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController inputCityController = new TextEditingController();
  Position position;
  var url;
  var weatherdata;

  void getTemperature(var mode) async {


    if (mode == 'gps') {
      bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();

      if (isLocationEnabled) {
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print(position);
        url = "http://api.openweathermap.org/data/2.5/weather?lat=" +
            position.latitude.toString() +
            "&lon=" +
            position.longitude.toString() +
            "&units=metric&appid=647fa9b621b3432e2d6789793ad6e1fd";
        getDatafromOpenWeatherMap();
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: "Please turn on GPS to know the current location weather.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
        });
      }
    } else {
      if (inputCityController.text.length > 0)
      {
        url = 'http://api.openweathermap.org/data/2.5/weather?q=' +
            inputCityController.text +
            '&appid=647fa9b621b3432e2d6789793ad6e1fd&units=metric';

       getDatafromOpenWeatherMap();
      }
    }
  }

  void getDatafromOpenWeatherMap() async
  {
    Response response = await get(url);
    if (response.statusCode == 200) {
      weatherdata = jsonDecode(response.body);
      var temp = weatherdata['main']['temp'];
      print(temp.round());

      setState(() {
        visibleStatus = true;
        cityController.text = weatherdata['name'];
        tempController.text = temp.round().toString() + "°";
      });
    } else {
      setState(() {
        visibleStatus = false;
        cityController.text = "Invalid city";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        //          appBar: AppBar(title: Text('Greet Me'),),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage("images/weatherimage.jpg"),
                  fit: BoxFit.cover)),
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(),
                    child: Text("Weather",
                        style: TextStyle(
                            fontFamily: 'Dance',
                            color: Colors.white,
                            fontSize: 30)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: TextFormField(
                      controller: inputCityController,
                      style: TextStyle(color: Colors.white),
                      decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        hintText: "Enter city name",
                        hintStyle: TextStyle(color: Colors.white),
                        helperText:
                            '                  Source: openweathermap.org',
                        helperStyle: TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.location_city,
                          color: Colors.white,
                        ),
                        fillColor: Colors.red,
                        contentPadding: EdgeInsets.all(15),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      getTemperature('city');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
//                      side: BorderSide(color: Colors.red)
                    ),
                    child: Text(
                      "Get temperature",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xff002535),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      getTemperature('gps');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
//                      side: BorderSide(color: Colors.red)
                    ),
                    child: Text(
                      "Use my location",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xff002535),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                  visible: visibleStatus,
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  )),
                              Text(
                                " " + cityController.text,
                                style: TextStyle(
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(5.0, 5.0),
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: "Pacific"),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: visibleStatus,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  tempController.text,
                                  style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 3.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                      fontSize: 140.0,
                                      color: Colors.white,
                                      fontFamily: "Acme"),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Text(
                                    "C",
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(5.0, 5.0),
                                            blurRadius: 3.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                        fontSize: 80.0,
                                        color: Colors.white,
                                        fontFamily: "Acme"),
                                  ),
                                ),
                              ],
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
}
