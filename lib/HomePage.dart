import 'package:flutter/cupertino.dart'
    show
        Axis,
        BuildContext,
        Color,
        Column,
        Container,
        EdgeInsets,
        FontWeight,
        GestureDetector,
        Icon,
        Key,
        ListView,
        MainAxisAlignment,
        Navigator,
        Row,
        Stack,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        Widget;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:date_format/date_format.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weather/Constant.dart';
import 'package:weather/AnimatedSplashScreen.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  final String ms = "м/с";
  final String c = "°C";
  var weatherData;
  List<Widget> tiles;
  bool _loading = true;
  Future<String> getWeatherData() async {
    var response = await http.get(
        Uri.encodeFull(
            "http://api.openweathermap.org/data/2.5/forecast?id=706483&units=metric&APPID=73d6a82d22fe51972025349900e04a6f"),
        headers: {'Accept': 'application/json'});

    this.setState(() {
      weatherData = json.decode(response.body);
      _loading = false;
    });
    return "";
  }

  @override
  void initState() {
    this.getWeatherData();
    super.initState();
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(animatedSplash);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildTile() {
      this.tiles = [];
      for (var i = 0; i < 40; i++) {
        this.tiles.add(
              Column(
                children: <Widget>[
                  Text(
                    formatDate(
                        DateTime.fromMillisecondsSinceEpoch(
                            weatherData['list'][i]['dt'] * 1000),
                        [d, '.', mm]).toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    formatDate(
                        DateTime.fromMillisecondsSinceEpoch(
                            weatherData['list'][i]['dt'] * 1000),
                        [HH, ':', nn]).toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    weatherData['list'][i]['main']['temp'].ceil().toString() +
                        '°C',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: "http://openweathermap.org/img/w/" +
                              weatherData['list'][i]['weather'][0]['icon'] +
                              ".png",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fadeOutDuration: Duration(seconds: 1),
                          fadeInDuration: Duration(seconds: 3),
                          width: 70,
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    (weatherData['list'][i]['main']['pressure'] * 0.750062)
                        .ceil()
                        .toString(),
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "мм.рт.ст",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    weatherData['list'][i]['wind']['speed'].ceil().toString() +
                        " м/с",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
      }
      return this.tiles;
    }

    return (_loading)
        ? AnimatedSplashScreen()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                backgroundColor: Colors.lightBlue,
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  titleSpacing: 2.0,
                  title: Text(
                    "Погода а Харькове",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  automaticallyImplyLeading: false,
                ),
                body: Stack(
                  children: <Widget>[
                    Card(
                      elevation: 0.7,
                      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                      color: Color.fromRGBO(3, 169, 244, 0.4),
                      child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              height: 240,
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                              child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  children: buildTile()))),
                    ),
                  ],
                )));
  }
}
