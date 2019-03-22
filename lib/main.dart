import 'dart:async' show Future;
import 'package:weather/Constant.dart';
import 'package:weather/AnimatedSplashScreen.dart';
import 'package:weather/HomePage.dart';
import 'package:flutter/material.dart';

Future main() async {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      primarySwatch: Colors.red,
    ),
    home: new HomeScreen(),
    routes: <String, WidgetBuilder>{
      homeScreen: (BuildContext context) => new HomeScreen(),
      animatedSplash: (BuildContext context) => new AnimatedSplashScreen()
    },
  ));
}
