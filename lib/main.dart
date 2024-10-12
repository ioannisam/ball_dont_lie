import 'package:flutter/material.dart';
import 'package:ball_dont_lie/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => Home()
    }
  ));
}

